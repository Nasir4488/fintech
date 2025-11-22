import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../Provider/ScholarshipService.dart';

class ScholarshipManagerScreen extends StatefulWidget {
  const ScholarshipManagerScreen({super.key});

  @override
  State<ScholarshipManagerScreen> createState() => _ScholarshipManagerScreenState();
}

class _ScholarshipManagerScreenState extends State<ScholarshipManagerScreen>
    with SingleTickerProviderStateMixin {
  List<String> allScholarships = [];
  Map<String, List<String>> scholarshipApplicants = {};
  Map<String, List<String>> scholarshipWinners = {};
  String? selectedScholarship;
  bool _isLoading = false;
  bool _isContractProcessing = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  var service = Get.put(ScholarshipService());
  final TextEditingController _scholarshipNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _loadAllScholarships();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scholarshipNameController.dispose();
    super.dispose();
  }

  Future<void> _loadAllScholarships() async {
    setState(() => _isLoading = true);
    try {
      await service.init();
      print('=== Loading scholarships ===');

      List<String> scholarships = await service.getAllScholarshipNames();
      print('getAllScholarshipNames result: $scholarships');

      if (scholarships.isEmpty) {
        print('Trying fallback method...');
        scholarships = await service.getScholarshipsFromEvents();
        print('Fallback method result: $scholarships');
      }

      final Map<String, List<String>> applicants = {};
      final Map<String, List<String>> winners = {};

      for (String scholarship in scholarships) {
        try {
          print('Loading data for scholarship: $scholarship');
          applicants[scholarship] = await service.getScholarshipApplicants(scholarship);
          winners[scholarship] = await service.getScholarshipWinners(scholarship);
          print('Loaded ${applicants[scholarship]?.length ?? 0} applicants and ${winners[scholarship]?.length ?? 0} winners for $scholarship');
        } catch (e) {
          print('Error loading data for scholarship $scholarship: $e');
          applicants[scholarship] = [];
          winners[scholarship] = [];
        }
      }

      setState(() {
        allScholarships = scholarships;
        scholarshipApplicants = applicants;
        scholarshipWinners = winners;
      });

      print('=== Final result ===');
      print('Total scholarships loaded: ${allScholarships.length}');
      print('Scholarships: $allScholarships');

    } catch (e) {
      _showError('Error loading scholarships: ${e.toString()}');
      print('=== Load scholarships error ===');
      print('Error: $e');
      print('Stack trace: ${StackTrace.current}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _showConfirmDialog(String title, String content) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _runDiagnostic() async {
    try {
      await service.debugContract();
      _showSuccess('Check console for diagnostic results');
    } catch (e) {
      _showError('Diagnostic failed: $e');
      print("Diagnostic error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
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
                      colors: [Colors.deepPurple[600]!, Colors.deepPurple[400]!],
                    ),
                  ),
                ),
                title: const Text(
                  'Scholarship Manager',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _loadAllScholarships,
                ),
                IconButton(
                  icon: const Icon(Icons.analytics_outlined, color: Colors.white),
                  onPressed: _runDiagnostic,
                  tooltip: 'Run Diagnostic',
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: _isLoading
                  ? Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading scholarships from blockchain...'),
                    ],
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Stats Card
                    _buildStatsCard(),
                    const SizedBox(height: 24),

                    // Scholarships List
                    _buildScholarshipsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    int totalScholarships = allScholarships.length;
    int totalApplicants = scholarshipApplicants.values.fold(0, (sum, list) => sum + list.length);
    int totalWinners = scholarshipWinners.values.fold(0, (sum, list) => sum + list.length);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple[600]!, Colors.deepPurple[400]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.dashboard, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              const Text(
                "Scholarship Overview",
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
                child: _buildStatItem("Programs", totalScholarships, Colors.cyan, Icons.school),
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              Expanded(
                child: _buildStatItem("Applicants", totalApplicants, Colors.orange, Icons.people_outline),
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              Expanded(
                child: _buildStatItem("Winners", totalWinners, Colors.green, Icons.emoji_events),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildScholarshipsList() {
    if (allScholarships.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
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
            Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No scholarships found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create one to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Scholarships (${allScholarships.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...allScholarships.map((scholarshipName) {
          final applicants = scholarshipApplicants[scholarshipName] ?? [];
          final winners = scholarshipWinners[scholarshipName] ?? [];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
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
            child: ExpansionTile(
              tilePadding: const EdgeInsets.all(20),
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school,
                  color: Colors.deepPurple[600],
                  size: 24,
                ),
              ),
              title: Text(
                scholarshipName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    _buildInfoChip('${applicants.length} Applicants', Icons.people_outline, Colors.blue),
                    const SizedBox(width: 8),
                    _buildInfoChip('${winners.length} Winners', Icons.emoji_events, Colors.green),
                  ],
                ),
              ),
              children: [
                if (applicants.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Applicants:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...applicants.map((applicant) {
                        final isWinner = winners.contains(applicant);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isWinner ? Colors.green[50] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isWinner ? Colors.green[200]! : Colors.grey[200]!,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: isWinner ? Colors.green[100] : Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  size: 16,
                                  color: isWinner ? Colors.green[700] : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  applicant,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isWinner ? Colors.green[100] : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isWinner ? 'Winner' : 'Applicant',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isWinner ? Colors.green[700] : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'No applicants yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}