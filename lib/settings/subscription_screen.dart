import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFBBF24).withAlpha((255 * 0.2).round()),
                      const Color(0xFFFBBF24).withAlpha((255 * 0.05).round()),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFFBBF24).withAlpha((255 * 0.3).round()),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      size: 80,
                      color: Color(0xFFFBBF24),
                    ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 24),
                    Text(
                      'Premium Features',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: const Color(0xFFFBBF24),
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 8),
                    Text(
                      'Coming Soon',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF737373),
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              _buildFeatureItem(
                icon: Icons.cloud_upload_outlined,
                title: 'Cloud Sync',
                description: 'Sync your data across all devices',
              ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2, end: 0),
              
              const SizedBox(height: 16),
              
              _buildFeatureItem(
                icon: Icons.color_lens_outlined,
                title: 'Custom Themes',
                description: 'Personalize your app appearance',
              ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2, end: 0),
              
              const SizedBox(height: 16),
              
              _buildFeatureItem(
                icon: Icons.analytics_outlined,
                title: 'Advanced Analytics',
                description: 'Deep insights into your life journey',
              ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.2, end: 0),
              
              const SizedBox(height: 16),
              
              _buildFeatureItem(
                icon: Icons.memory_outlined,
                title: 'Unlimited Milestones',
                description: 'No limit on milestone creation',
              ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.2, end: 0),
              
              const SizedBox(height: 16),
              
              _buildFeatureItem(
                icon: Icons.backup_outlined,
                title: 'Automatic Backups',
                description: 'Never lose your precious memories',
              ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.2, end: 0),
              
              const SizedBox(height: 32),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF262626),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF404040)),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.notifications_active_outlined,
                      size: 48,
                      color: Color(0xFFFF6B35),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Get Notified',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'re working hard to bring premium features. Be the first to know when they launch!',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 900.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF404040)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFBBF24).withAlpha((255 * 0.1).round()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFBBF24),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF737373),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
