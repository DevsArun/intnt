import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart';
import '../life_map/life_map_screen.dart';
import '../widgets/loading_button.dart';

class AgeInputScreen extends StatefulWidget {
  const AgeInputScreen({super.key});

  @override
  State<AgeInputScreen> createState() => _AgeInputScreenState();
}

class _AgeInputScreenState extends State<AgeInputScreen> {
  int _currentAge = 25;
  int _selectedMonth = DateTime.now().month;
  bool _isLoading = false;

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  Future<void> _handleContinue() async {
    setState(() => _isLoading = true);

    final birthYear = DateTime.now().year - _currentAge;

    try {
      final response = await ApiService.updateProfile(
        birthYear: birthYear,
        birthMonth: _selectedMonth,
      );

      if (!mounted) return;

      if (response['success'] == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LifeMapScreen()),
        );
      } else {
        _showError('Failed to save age');
      }
    } catch (e) {
      if (mounted) _showError('Connection error');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              Text(
                'How old are you?',
                style: Theme.of(context).textTheme.displayLarge,
              ).animate().fadeIn().slideX(begin: -0.2, end: 0),
              
              const SizedBox(height: 12),
              
              Text(
                'This helps us calculate your life in months',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF737373),
                ),
              ).animate().fadeIn(delay: 100.ms),
              
              const Spacer(),
              
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withAlpha((255 * 0.1).round()),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFFF6B35).withAlpha((255 * 0.3).round()),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '$_currentAge',
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF6B35),
                          height: 1,
                        ),
                      ),
                    ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'years old',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFF737373),
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFFFF6B35),
                  inactiveTrackColor: const Color(0xFF404040),
                  thumbColor: const Color(0xFFFF6B35),
                  overlayColor: const Color(0xFFFF6B35).withAlpha((255 * 0.2).round()),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 14,
                  ),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: _currentAge.toDouble(),
                  min: 1,
                  max: 90,
                  divisions: 89,
                  onChanged: (value) {
                    setState(() => _currentAge = value.round());
                  },
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 48),
              
              Text(
                'Birth Month',
                style: Theme.of(context).textTheme.headlineMedium,
              ).animate().fadeIn(delay: 400.ms),
              
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF262626),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF404040)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedMonth,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF262626),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFFFF6B35),
                    ),
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text(_months[index]),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedMonth = value);
                      }
                    },
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),
              
              const Spacer(),
              
              LoadingButton(
                onPressed: _handleContinue,
                isLoading: _isLoading,
                text: 'Continue',
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
