import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart';
import '../widgets/loading_button.dart';

class AddMilestoneScreen extends StatefulWidget {
  const AddMilestoneScreen({super.key});

  @override
  State<AddMilestoneScreen> createState() => _AddMilestoneScreenState();
}

class _AddMilestoneScreenState extends State<AddMilestoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _reasonController = TextEditingController();
  
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  String _selectedColor = '#FF6B35';
  bool _isLoading = false;

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final List<Map<String, dynamic>> _colors = [
    {'name': 'Orange', 'hex': '#FF6B35'},
    {'name': 'Blue', 'hex': '#3B82F6'},
    {'name': 'Purple', 'hex': '#8B5CF6'},
    {'name': 'Pink', 'hex': '#EC4899'},
    {'name': 'Green', 'hex': '#10B981'},
    {'name': 'Yellow', 'hex': '#F59E0B'},
    {'name': 'Red', 'hex': '#EF4444'},
    {'name': 'Cyan', 'hex': '#06B6D4'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.createMilestone(
        title: _titleController.text.trim(),
        reason: _reasonController.text.trim(),
        targetYear: _selectedYear,
        targetMonth: _selectedMonth,
        color: _selectedColor,
      );

      if (!mounted) return;

      if (response['success'] == true) {
        Navigator.pop(context, true);
      } else {
        _showError(response['error'] ?? 'Failed to create milestone');
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
      appBar: AppBar(
        title: const Text('Add Milestone'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a Milestone',
                  style: Theme.of(context).textTheme.displaySmall,
                ).animate().fadeIn().slideX(begin: -0.2, end: 0),
                
                const SizedBox(height: 8),
                
                Text(
                  'Mark important moments in your life journey',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF737373),
                  ),
                ).animate().fadeIn(delay: 100.ms),
                
                const SizedBox(height: 32),
                
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'e.g., Started my first job',
                    prefixIcon: Icon(Icons.title),
                  ),
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 20),
                
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason (Optional)',
                    hintText: 'Why is this milestone important?',
                    prefixIcon: Icon(Icons.description_outlined),
                    alignLabelWithHint: true,
                  ),
                  maxLength: 200,
                  maxLines: 3,
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 24),
                
                Text(
                  'Target Date',
                  style: Theme.of(context).textTheme.headlineMedium,
                ).animate().fadeIn(delay: 400.ms),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: Container(
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
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF262626),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF404040)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _selectedYear,
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
                            items: List.generate(200, (index) {
                              final year = 1900 + index;
                              return DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              );
                            }),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedYear = value);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 32),
                
                Text(
                  'Color',
                  style: Theme.of(context).textTheme.headlineMedium,
                ).animate().fadeIn(delay: 600.ms),
                
                const SizedBox(height: 16),
                
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _colors.map((color) {
                    final isSelected = _selectedColor == color['hex'];
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedColor = color['hex']);
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Color(int.parse(
                            color['hex'].replaceFirst('#', '0xFF'),
                          )),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Color(int.parse(
                                      color['hex'].replaceFirst('#', '0xFF'),
                                    )).withAlpha((255 * 0.5).round()),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 28,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3, end: 0),
                
                const SizedBox(height: 48),
                
                LoadingButton(
                  onPressed: _handleSave,
                  isLoading: _isLoading,
                  text: 'Create Milestone',
                ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
