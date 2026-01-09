import 'package:google_sign_in/google_sign_in.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  static Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        return {'success': false, 'error': 'Sign in cancelled'};
      }

      final response = await ApiService.googleLogin(
        account.id,
        account.email,
        account.displayName ?? '',
        account.photoUrl ?? '',
      );

      if (response['success'] == true) {
        await StorageService.saveToken(response['token']);
      }

      return response;
    } catch (e) {
      return {'success': false, 'error': 'Sign in failed: $e'};
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await StorageService.deleteToken();
  }
}
