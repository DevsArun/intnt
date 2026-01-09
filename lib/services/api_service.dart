import 'dart:convert';
import 'package:dio/dio.dart';
import 'storage_service.dart';
import 'dart:developer' as developer;

class ApiService {
  static const String baseUrl = 'https://app.devsarun.io';

  // Using Dio for robust, cross-platform (Mobile + Web) request handling.
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // This header can help servers identify the request as AJAX.
        'X-Requested-With': 'XMLHttpRequest',
      },
      // THE KEY FIX: Do not follow redirects. Let us handle them.
      followRedirects: false,
      // Treat redirect status codes as a success so we can inspect the response.
      validateStatus: (status) {
        return status != null && status < 500; // Accept all non-server-error statuses
      },
    ),
  );

  static Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint,
    Map<String, dynamic>? data,
    {String? token}
  ) async {
    try {
      developer.log('📡 $method $baseUrl$endpoint', name: 'ApiService');
      if (data != null) developer.log('📦 Body: $data', name: 'ApiService');

      final options = Options(method: method, headers: {});
      if (token != null) {
        options.headers!['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.request(
        endpoint,
        data: data,
        options: options,
      );

      developer.log('✅ Status: ${response.statusCode}', name: 'ApiService');
      developer.log('📥 Response Data: ${response.data}', name: 'ApiService');

      // THE SECOND KEY FIX: Explicitly check for redirect status codes.
      if (response.statusCode! >= 300 && response.statusCode! < 400) {
        final location = response.headers['location'];
        developer.log('🛑 REDIRECT DETECTED to: $location', name: 'ApiService');
        return {
          'success': false,
          'error': 'Backend Misconfiguration: The server is redirecting API calls. Please fix the endpoint: $endpoint'
        };
      }

      // Process the response data.
      if (response.data == null || response.data == '') {
        return {'success': true, 'data': 'Success'};
      }

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }

      // If response is a string, try to decode it.
      if (response.data is String) {
        try {
          return json.decode(response.data) as Map<String, dynamic>;
        } catch (e) {
          developer.log('⚠️ JSON decode failed for string response.', name: 'ApiService');
          return {'success': false, 'error': 'Invalid response format from server.'};
        }
      }
      
      return {'success': false, 'error': 'Unhandled response type'};

    } on DioException catch (e) {
      developer.log('❌ Dio Error: ${e.message}', name: 'ApiService', error: e);
      if (e.response != null) {
        developer.log('❌ Dio Error Response: ${e.response?.data}', name: 'ApiService');
      }
      return {'success': false, 'error': 'Connection failed. Please check network or server status.'};
    } catch (e, s) {
       developer.log('❌ Unknown Error: $e', name: 'ApiService', error: e, stackTrace: s);
      return {'success': false, 'error': 'An unexpected error occurred.'};
    }
  }

  // --- API Methods using the robust _makeRequest function ---

  static Future<Map<String, dynamic>> register(String email, String password) async {
    return await _makeRequest('POST', '/api/auth.php', {
      'action': 'register',
      'email': email,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    return await _makeRequest('POST', '/api/auth.php', {
      'action': 'login',
      'email': email,
      'password': password,
    });
  }

  static Future<Map<String, dynamic>> googleLogin(
    String googleId,
    String email,
    String fullName,
    String profilePicture,
  ) async {
    return await _makeRequest('POST', '/api/auth.php', {
      'action': 'google_login',
      'google_id': googleId,
      'email': email,
      'full_name': fullName,
      'profile_picture': profilePicture,
    });
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await StorageService.getToken();
    return await _makeRequest('GET', '/api/users.php', null, token: token);
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    int? birthYear,
    int? birthMonth,
  }) async {
    final token = await StorageService.getToken();
    return await _makeRequest('PUT', '/api/users.php', {
      'full_name': fullName,
      'birth_year': birthYear,
      'birth_month': birthMonth,
    }, token: token);
  }

  static Future<Map<String, dynamic>> getMilestones() async {
    final token = await StorageService.getToken();
    return await _makeRequest('GET', '/api/milestones.php', null, token: token);
  }

  static Future<Map<String, dynamic>> createMilestone({
    required String title,
    required String reason,
    required int targetYear,
    required int targetMonth,
    String color = '#FF6B35',
  }) async {
    final token = await StorageService.getToken();
    return await _makeRequest('POST', '/api/milestones.php', {
      'title': title,
      'reason': reason,
      'target_year': targetYear,
      'target_month': targetMonth,
      'color': color,
    }, token: token);
  }

  static Future<Map<String, dynamic>> updateMilestone({
    required int id,
    required String title,
    required String reason,
    required int targetYear,
    required int targetMonth,
    String color = '#FF6B35',
    int isCompleted = 0,
  }) async {
    final token = await StorageService.getToken();
    return await _makeRequest('PUT', '/api/milestones.php', {
      'id': id,
      'title': title,
      'reason': reason,
      'target_year': targetYear,
      'target_month': targetMonth,
      'color': color,
      'is_completed': isCompleted,
    }, token: token);
  }

  static Future<Map<String, dynamic>> deleteMilestone(int id) async {
    final token = await StorageService.getToken();
    return await _makeRequest('DELETE', '/api/milestones.php', {'id': id}, token: token);
  }

  static Future<Map<String, dynamic>> getSettings() async {
    return await _makeRequest('GET', '/api/settings.php', null);
  }
}
