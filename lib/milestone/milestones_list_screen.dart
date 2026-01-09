import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/milestone_model.dart';
import '../services/api_service.dart';
import 'add_milestone_screen.dart';
import 'edit_milestone_screen.dart';

class MilestonesListScreen extends StatefulWidget {
  const MilestonesListScreen({super.key});

  @override
  State<MilestonesListScreen> createState() => _MilestonesListScreenState();
}

class _MilestonesListScreenState extends State<MilestonesListScreen> {
  List<MilestoneModel> _milestones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMilestones();
  }

  Future<void> _loadMilestones() async {
    setState(() => _isLoading = true);

    try {
      final response = await ApiService.getMilestones();

      if (mounted && response['success'] == true) {
        setState(() {
          _milestones = (response['milestones'] as List)
              .map((m) => MilestoneModel.fromJson(m))
              .toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load milestones')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            )
          : _milestones.isEmpty
              ? _buildEmptyState()
              : _buildMilestonesList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMilestoneScreen()),
          ).then((result) {
            if (result == true) _loadMilestones();
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Milestone'),
        backgroundColor: const Color(0xFFFF6B35),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withAlpha((255 * 0.1).round()),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.flag_outlined,
                size: 60,
                color: Color(0xFFFF6B35),
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text(
              'No Milestones Yet',
              style: Theme.of(context).textTheme.headlineMedium,
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 8),
            Text(
              'Start marking important moments in your life journey',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestonesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _milestones.length,
      itemBuilder: (context, index) {
        final milestone = _milestones[index];
        return _buildMilestoneCard(milestone, index);
      },
    );
  }

  Widget _buildMilestoneCard(MilestoneModel milestone, int index) {
    final color = Color(int.parse(milestone.color.replaceFirst('#', '0xFF')));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditMilestoneScreen(milestone: milestone),
              ),
            ).then((result) {
              if (result == true) _loadMilestones();
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF404040)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestone.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (milestone.reason != null && milestone.reason!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          milestone.reason!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 16,
                            color: Color(0xFF737373),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_getMonthName(milestone.targetMonth)} ${milestone.targetYear}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (milestone.isCompleted) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withAlpha((255 * 0.2).round()),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Completed',
                                style: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF737373),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 50 * index))
        .slideX(begin: 0.2, end: 0);
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
