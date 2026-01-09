import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _onboardingKey = 'onboarding_complete';
  
  // Simple in-memory storage for web (IDX doesn't support secure storage properly)
  static String? _cachedToken;
  
  static Future<void> saveToken(String token) async {
    _cachedToken = token;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e, s) {
      developer.log('Error saving token: $e', name: 'StorageService', error: e, stackTrace: s);
    }
  }
  
  static Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedToken = prefs.getString(_tokenKey);
      return _cachedToken;
    } catch (e, s) {
      developer.log('Error getting token: $e', name: 'StorageService', error: e, stackTrace: s);
      return null;
    }
  }
  
  static Future<void> deleteToken() async {
    _cachedToken = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (e, s) {
      developer.log('Error deleting token: $e', name: 'StorageService', error: e, stackTrace: s);
    }
  }
  
  static Future<void> setOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
    } catch (e, s) {
      developer.log('Error setting onboarding: $e', name: 'StorageService', error: e, stackTrace: s);
    }
  }
  
  static Future<bool> isOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingKey) ?? false;
    } catch (e, s) {
      developer.log('Error checking onboarding: $e', name: 'StorageService', error: e, stackTrace: s);
      return false;
    }
  }
}
