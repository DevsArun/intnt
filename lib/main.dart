import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'auth/splash_screen.dart';  // ✅ Use splash screen (jo exist karta hai)
import 'onboarding/age_input_screen.dart';  // ✅ Exists [file:81]
import 'life_map/life_map_screen.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final String? token = await StorageService.getToken();
  Widget initialScreen = const SplashScreen();  // ✅ Use SplashScreen instead

  if (token != null && token.isNotEmpty) {
    print('🔐 Token found: ${token.substring(0, 20)}...');
    
    try {
      final response = await ApiService.getProfile();
      
      if (response['success'] == true) {
        final user = response['user'];
        print('✅ User authenticated: ${user['email']}');
        
        if (user['birth_year'] != null && user['birth_month'] != null) {
          print('✅ Profile complete → LifeMapScreen');
          initialScreen = const LifeMapScreen();
        } else {
          print('⚠️ Profile incomplete → AgeInputScreen');
          initialScreen = const AgeInputScreen();
        }
      } else {
        print('❌ Token invalid: ${response['error']}');
        await StorageService.deleteToken();
      }
    } catch (e) {
      print('❌ Error checking token: $e');
      await StorageService.deleteToken();
    }
  } else {
    print('ℹ️ No token found → SplashScreen');
  }

  runApp(LifeInMonthsApp(initialScreen: initialScreen));
}
