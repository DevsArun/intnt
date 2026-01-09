import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simple delay, no authentication check for now
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Always go to welcome screen (bypass auth check to avoid loop)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
          ),
        ),
        child: Center(
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
                  Icons.calendar_month_rounded,
                  size: 60,
                  color: Color(0xFFFF6B35),
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              
              const SizedBox(height: 32),
              
              Text(
                'Life in Months',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 8),
              
              Text(
                'Visualize your life journey',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF737373),
                ),
              ).animate().fadeIn(delay: 400.ms),
              
              const SizedBox(height: 48),
              
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
