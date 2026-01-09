import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// ❌ REMOVE THIS LINE:
// import 'package:screenshot/screenshot.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../models/milestone_model.dart';
import '../milestone/add_milestone_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/life_grid.dart';
import 'widgets/stats_card.dart';
import 'widgets/live_clock.dart';

class LifeMapScreen extends StatefulWidget {
  const LifeMapScreen({super.key});

  @override
  State<LifeMapScreen> createState() => _LifeMapScreenState();
}

class _LifeMapScreenState extends State<LifeMapScreen> {
  // ❌ REMOVE THIS LINE:
  // final ScreenshotController _screenshotController = ScreenshotController();
  
  UserModel? _user;
  List<MilestoneModel> _milestones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final profileResponse = await ApiService.getProfile();
      final milestonesResponse = await ApiService.getMilestones();

      if (mounted && profileResponse['success'] == true) {
        setState(() {
          _user = UserModel.fromJson(profileResponse['user']);
          if (milestonesResponse['success'] == true) {
            _milestones = (milestonesResponse['milestones'] as List)
                .map((m) => MilestoneModel.fromJson(m))
                .toList();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load data'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int get _currentMonthIndex {
    if (_user?.birthYear == null || _user?.birthMonth == null) return 0;
    
    final now = DateTime.now();
    final birth = DateTime(_user!.birthYear!, _user!.birthMonth!);
    final months = ((now.difference(birth).inDays) / 30).round();
    
    return months.clamp(0, 1079);
  }

  int get _livedMonths => _currentMonthIndex + 1;
  int get _remainingMonths => 1080 - _livedMonths;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF6B35),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const LiveClock().animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 24),
                    _buildStats(),
                    const SizedBox(height: 24),
                    // ✅ REMOVED Screenshot wrapper
                    Container(
                      color: const Color(0xFF1A1A1A),
                      padding: const EdgeInsets.all(24),
                      child: LifeGrid(
                        currentMonthIndex: _currentMonthIndex,
                        milestones: _milestones,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildActionButtons(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF404040), width: 1),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Life in Months',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                _user?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF737373),
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ).then((_) => _loadData());
            },
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: StatsCard(
              title: 'Lived',
              value: _livedMonths.toString(),
              subtitle: 'months',
              color: const Color(0xFFFF6B35),
            ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2, end: 0),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatsCard(
              title: 'Remaining',
              value: _remainingMonths.toString(),
              subtitle: 'months',
              color: const Color(0xFF10B981),
            ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddMilestoneScreen(),
                  ),
                ).then((_) => _loadData());
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Milestone'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 12),
          
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Share feature available on mobile app'),
                    backgroundColor: const Color(0xFFFF6B35),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.share_outlined),
              label: const Text('Share'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                side: const BorderSide(color: Color(0xFF404040)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }
}
