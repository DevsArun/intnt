import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'auth/splash_screen.dart';  // ✅ Use existing file

class LifeInMonthsApp extends StatelessWidget {
  final Widget initialScreen;

  const LifeInMonthsApp({
    super.key,
    this.initialScreen = const SplashScreen(),  // ✅ Default to SplashScreen
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life in Months',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: initialScreen,
    );
  }
}
