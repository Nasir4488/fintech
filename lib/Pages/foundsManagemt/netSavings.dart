import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../Models/transcation.dart';

class Netsavings extends StatefulWidget {
  List<UserTransaction> transactions;
  Netsavings({super.key, required this.transactions});

  @override
  State<Netsavings> createState() => _NetsavingsState();
}

class _NetsavingsState extends State<Netsavings>
    with SingleTickerProviderStateMixin {
  final List<String> income = ["Salary", "Freelance", "Business", "Investment"];
  final List<String> expenses = ["Rent", "Food", "Shopping", "Transport"];
  final transactionBox = Hive.box<UserTransaction>('transactions');
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  DateTime now = DateTime.now();
  String selectedPeriod = 'This Month';
  List<String> periods = ['This Month', 'Last Month', 'This Year', 'All Time'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<UserTransaction> _getFilteredTransactions() {
    List<UserTransaction> filtered = widget.transactions;

    switch (selectedPeriod) {
      case 'This Month':
        return filtered.where((t) =>
        t.date.month == now.month && t.date.year == now.year).toList();
      case 'Last Month':
        DateTime lastMonth = DateTime(now.year, now.month - 1);
        return filtered.where((t) =>
        t.date.month == lastMonth.month && t.date.year == lastMonth.year).toList();
      case 'This Year':
        return filtered.where((t) => t.date.year == now.year).toList();
      default:
        return filtered;
    }
  }

  double _getTotalIncome() {
    return _getFilteredTransactions()
        .where((t) => income.contains(t.category))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _getTotalExpenses() {
    return _getFilteredTransactions()
        .where((t) => expenses.contains(t.category))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double _getNetSavings() {
    return _getTotalIncome() - _getTotalExpenses();
  }

  Color _getCategoryColor(String category) {
    if (income.contains(category)) {
      switch (category) {
        case 'Salary': return Colors.blue;
        case 'Freelance': return Colors.purple;
        case 'Business': return Colors.orange;
        case 'Investment': return Colors.green;
        default: return Colors.grey;
      }
    } else {
      switch (category) {
        case 'Rent': return Colors.blue;
        case 'Food': return Colors.orange;
        case 'Shopping': return Colors.purple;
        case 'Transport': return Colors.green;
        default: return Colors.grey;
      }
    }
  }

  IconData _getCategoryIcon(String category) {
    if (income.contains(category)) {
      switch (category) {
        case 'Salary': return Icons.work_outline;
        case 'Freelance': return Icons.person_outline;
        case 'Business': return Icons.business_outlined;
        case 'Investment': return Icons.trending_up_outlined;
        default: return Icons.attach_money;
      }
    } else {
      switch (category) {
        case 'Rent': return Icons.home_outlined;
        case 'Food': return Icons.restaurant_outlined;
        case 'Shopping': return Icons.shopping_bag_outlined;
        case 'Transport': return Icons.directions_car_outlined;
        default: return Icons.category_outlined;
      }
    }
  }

  void _deleteTransaction(UserTransaction transaction, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              const Text("Delete Transaction"),
            ],
          ),
          content: const Text("Are you sure you want to delete this transaction?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  transaction.delete();
                  widget.transactions.removeAt(index);
                });
                Navigator.of(context).pop();
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Transaction deleted successfully'),
                      ],
                    ),
                    backgroundColor: Colors.red[400],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _getFilteredTransactions();
    final totalIncome = _getTotalIncome();
    final totalExpenses = _getTotalExpenses();
    final netSavings = _getNetSavings();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(_slideAnimation),
        child: FadeTransition(
          opacity: _slideAnimation,
          child: CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: netSavings >= 0
                            ? [Colors.amber[600]!, Colors.amber[400]!]
                            : [Colors.red[600]!, Colors.red[400]!],
                      ),
                    ),
                  ),
                  title: const Text(
                    "Net Savings",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  centerTitle: true,
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Period Selector
                      _buildPeriodSelector(),
                      const SizedBox(height: 20),

                      // Net Savings Card
                      _buildNetSavingsCard(netSavings),
                      const SizedBox(height: 20),

                      // Income vs Expenses Overview
                      _buildIncomeExpensesOverview(totalIncome, totalExpenses),
                      const SizedBox(height: 20),

                      // Savings Rate Card
                      _buildSavingsRateCard(totalIncome, netSavings),
                      const SizedBox(height: 20),

                      // All Transactions List
                      _buildTransactionsList(filteredTransactions),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: periods.map((period) {
          bool isSelected = selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedPeriod = period;
                });
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.amber[400] : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNetSavingsCard(double netSavings) {
    bool isPositive = netSavings >= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPositive
              ? [Colors.amber[600]!, Colors.amber[400]!]
              : [Colors.red[600]!, Colors.red[400]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isPositive ? Colors.amber : Colors.red).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isPositive ? Icons.savings_outlined : Icons.trending_down,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                isPositive ? "Net Savings" : "Net Loss",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "${isPositive ? '+' : ''}\$${netSavings.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedPeriod,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          if (!isPositive) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Spending exceeds income",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIncomeExpensesOverview(double totalIncome, double totalExpenses) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Income",
            totalIncome,
            Icons.trending_up,
            Colors.green,
            "+",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            "Expenses",
            totalExpenses,
            Icons.trending_down,
            Colors.red,
            "-",
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, double amount, IconData icon, Color color, String prefix) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            "$prefix\$${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsRateCard(double totalIncome, double netSavings) {
    double savingsRate = totalIncome > 0 ? (netSavings / totalIncome) * 100 : 0;
    bool isPositive = savingsRate >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.percent, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Savings Rate",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                "${savingsRate.toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: isPositive ? (savingsRate / 100).clamp(0.0, 1.0) : 0,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(
                        isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isPositive
                          ? "Great! You're saving money"
                          : "Consider reducing expenses",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(List<UserTransaction> transactions) {
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.history_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No transactions found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "No transactions for the selected period",
              style: TextStyle(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Sort transactions by date (newest first)
    transactions.sort((a, b) => b.date.compareTo(a.date));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "All Transactions (${transactions.length})",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
              indent: 20,
              endIndent: 20,
            ),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              String formattedDate = DateFormat("MMM dd, yyyy").format(transaction.date);
              bool isIncome = income.contains(transaction.category);

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(transaction.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(transaction.category),
                    color: _getCategoryColor(transaction.category),
                    size: 24,
                  ),
                ),
                title: Text(
                  transaction.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isIncome ? "Income" : "Expense",
                        style: TextStyle(
                          fontSize: 12,
                          color: isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      onSelected: (value) {
                        if (value == 'Delete') {
                          _deleteTransaction(transaction, index);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'Edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'Delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}