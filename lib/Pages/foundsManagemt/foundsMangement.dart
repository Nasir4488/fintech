import 'package:fin_tech/Pages/foundsManagemt/netSavings.dart';
import 'package:fin_tech/Pages/foundsManagemt/totalExpenses.dart';
import 'package:fin_tech/Pages/foundsManagemt/totalIncome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../Models/transcation.dart';

class Foundsmangement extends StatefulWidget {
  const Foundsmangement({super.key});

  @override
  State<Foundsmangement> createState() => _FoundsmangementState();
}

class _FoundsmangementState extends State<Foundsmangement>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final Box box = Hive.box('incomeBox');
  String? selectedCategory;
  OverlayEntry? overlayEntry;
  final GlobalKey dropdownKey = GlobalKey();
  late final Box<UserTransaction> transactionBox;
  late final Box incomeBox;
  bool isBoxOpen = false;
  List<UserTransaction> transactions = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Quick stats
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  double netSavings = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeHiveBoxes();
    _calculateQuickStats();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    overlayEntry?.remove();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  void _refreshData() {
    _calculateQuickStats();
    setState(() {});
  }

  void _initializeHiveBoxes() {
    try {
      transactionBox = Hive.box<UserTransaction>('transactions');
      incomeBox = Hive.box('incomeBox');
      print('Hive boxes initialized successfully');
      print('Transaction box length: ${transactionBox.length}');
    } catch (e) {
      print('Error initializing Hive boxes: $e');
    }
  }

  void _saveTransaction(UserTransaction transaction) {
    try {
      transactionBox.add(transaction);
      print('Transaction saved: ${transaction.category} - \$${transaction.amount}');
      _calculateQuickStats();
      setState(() {});
    } catch (e) {
      print('Error saving transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Failed to save transaction: $e'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _getAllTransactions() async {
    transactions = transactionBox.values.toList();
  }

  void _calculateQuickStats() {
    final allTransactions = transactionBox.values.toList();
    final now = DateTime.now();

    totalIncome = allTransactions
        .where((t) => ['Salary', 'Freelance', 'Business', 'Investment'].contains(t.category) &&
        t.date.month == now.month && t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);

    totalExpenses = allTransactions
        .where((t) => ['Rent', 'Food', 'Shopping', 'Transport'].contains(t.category) &&
        t.date.month == now.month && t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);

    netSavings = totalIncome - totalExpenses;
  }

  void _showDropDown(List<String> categories, Function(String) onSelected) {
    final renderBox = dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) => DropdownOverlay(
        position: position,
        size: size,
        categories: categories,
        onSelected: (category) {
          onSelected(category);
          overlayEntry?.remove();
          overlayEntry = null;
        },
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void _showInputDialog(String title, bool isIncome) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TransactionDialog(
        title: title,
        isIncome: isIncome,
        categories: isIncome
            ? ["Salary", "Freelance", "Business", "Investment"]
            : ["Rent", "Food", "Shopping", "Transport"],
        onSave: (transaction) {
          _saveTransaction(transaction);
          _showSuccessSnackbar(isIncome, transaction.amount.toString());
        },
        showDropDown: _showDropDown,
      ),
    );
  }

  void _showSuccessSnackbar(bool isIncome, String amount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text('${isIncome ? "Income" : "Expense"} of \$$amount added successfully!'),
          ],
        ),
        backgroundColor: isIncome ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
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
                      colors: [
                        Colors.indigo[600]!,
                        Colors.indigo[400]!,
                      ],
                    ),
                  ),
                ),
                title: const Text(
                  "Funds Management",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildQuickStatsCard(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                    const SizedBox(height: 24),
                    _buildMainGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo[600]!,
            Colors.indigo[400]!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.analytics, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              const Text(
                "Financial Overview",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem("Income", totalIncome, Colors.green, Icons.trending_up),
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              Expanded(
                child: _buildStatItem("Expenses", totalExpenses, Colors.red, Icons.trending_down),
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              Expanded(
                child: _buildStatItem("Savings", netSavings, Colors.amber, Icons.savings),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, double amount, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            "Add Income",
            Icons.add_circle,
            Colors.green,
                () => _showInputDialog('Add Income', true),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            "Add Expense",
            Icons.remove_circle,
            Colors.red,
                () => _showInputDialog('Add Expenses', false),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainGrid() {
    final gridItems = [
      GridItem('Total Income', Icons.trending_up_outlined, Colors.green, () async {
        await _getAllTransactions();
        final result = await Get.to(() => Totalincome(transactions: transactions));
        _refreshData();
      }),
      GridItem('Total Expenses', Icons.trending_down_outlined, Colors.red, () async {
        await _getAllTransactions();
        final result = await Get.to(() => Totalexpenses(transactions: transactions));
        _refreshData();
      }),
      GridItem('Net Savings', Icons.account_balance_wallet_outlined, Colors.blue, () async {
        await _getAllTransactions();
        final result = await Get.to(() => Netsavings(transactions: transactions));
        _refreshData();
      }),
      GridItem('Transaction History', Icons.history_outlined, Colors.purple, () {}),
      GridItem('Monthly Report', Icons.pie_chart_outline, Colors.orange, () {}),
      GridItem('Budget Planning', Icons.timeline_outlined, Colors.teal, () {}),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: gridItems.length,
      itemBuilder: (context, index) {
        final item = gridItems[index];
        return _buildModernGridTile(
          item.title,
          item.icon,
          item.color,
          item.onTap,
          index,
        );
      },
    );
  }

  Widget _buildModernGridTile(String title, IconData icon, Color color, VoidCallback onTap, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200 + (index * 100)),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GridItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  GridItem(this.title, this.icon, this.color, this.onTap);
}

class TransactionDialog extends StatefulWidget {
  final String title;
  final bool isIncome;
  final List<String> categories;
  final Function(UserTransaction) onSave;
  final Function(List<String>, Function(String)) showDropDown;

  const TransactionDialog({
    super.key,
    required this.title,
    required this.isIncome,
    required this.categories,
    required this.onSave,
    required this.showDropDown,
  });

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _dropdownKey = GlobalKey();
  String? _selectedCategory;
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  bool get _isFormValid => _selectedCategory != null && _controller.text.isNotEmpty;

  void _showDropDown() {
    final renderBox = _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => DropdownOverlay(
        position: position,
        size: size,
        categories: widget.categories,
        onSelected: (category) {
          setState(() {
            _selectedCategory = category;
          });
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _handleSave() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();
    try {
      double amount = double.parse(_controller.text);
      UserTransaction newTransaction = UserTransaction(
        category: _selectedCategory!,
        amount: amount,
        date: DateTime.now(),
      );

      widget.onSave(newTransaction);
      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid amount format'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.isIncome ? Icons.trending_up : Icons.trending_down,
                    color: widget.isIncome ? Colors.green : Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Category",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showDropDown,
              child: Container(
                key: _dropdownKey,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory ?? "Select Category",
                      style: TextStyle(
                        color: _selectedCategory != null ? Colors.black87 : Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Amount",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Enter amount",
                prefixText: "\$ ",
                prefixStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.isIncome ? Colors.green : Colors.red, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid
                          ? (widget.isIncome ? Colors.green : Colors.red)
                          : Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownOverlay extends StatefulWidget {
  final Offset position;
  final Size size;
  final List<String> categories;
  final Function(String) onSelected;

  const DropdownOverlay({
    super.key,
    required this.position,
    required this.size,
    required this.categories,
    required this.onSelected,
  });

  @override
  State<DropdownOverlay> createState() => _DropdownOverlayState();
}

class _DropdownOverlayState extends State<DropdownOverlay>
    with SingleTickerProviderStateMixin {
  int? hoveredIndex;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onSelected(widget.categories[0]),
          ),
        ),
        Positioned(
          top: widget.position.dy + widget.size.height + 4,
          left: widget.position.dx,
          width: widget.size.width,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              shadowColor: Colors.black.withOpacity(0.1),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: widget.categories.length,
                  separatorBuilder: (_, __) => Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) => MouseRegion(
                    onEnter: (_) => setState(() => hoveredIndex = index),
                    onExit: (_) => setState(() => hoveredIndex = null),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        widget.onSelected(widget.categories[index]);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        color: hoveredIndex == index
                            ? Colors.indigo.withOpacity(0.1)
                            : null,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Text(
                          widget.categories[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: hoveredIndex == index ? FontWeight.w600 : FontWeight.normal,
                            color: hoveredIndex == index ? Colors.indigo : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}