import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
// ❌ REMOVE THIS LINE:
// import 'services/auth_service.dart';
import 'auth/splash_screen.dart';

class LifeInMonthsApp extends StatelessWidget {
  const LifeInMonthsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life in Months',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
