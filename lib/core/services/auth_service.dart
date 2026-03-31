import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/singleton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileDataUpload {
  final String email;
  final String password;
  final String name;
  final String bio;
  final String gender;
  ProfileDataUpload({
    required this.email,
    required this.password,
    required this.name,
    required this.bio,
    required this.gender,
  });
}

class AuthService {
  static Future<GoogleSignIn> _buildGoogleSignIn() async {
    final signIn = GoogleSignIn.instance;
    await signIn.initialize(
      serverClientId: dotenv.env['WEB_CLIENT'],
      clientId: defaultTargetPlatform == TargetPlatform.android
          ? dotenv.env['ANDROID_CLIENT']
          : defaultTargetPlatform == TargetPlatform.iOS
              ? dotenv.env['IOS_CLIENT']
              : dotenv.env['WEB_CLIENT'],
    );
    return signIn;
  }

  static Future<void> _ensureProfileExists(
    User user, {
    String? fallbackEmail,
    String? fallbackName,
  }) async {
    final existing = await supabase
        .from('profiles')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    if (existing != null) return;

    final metadata = user.userMetadata;
    final profile = Profile(
      id: user.id,
      email: user.email ?? fallbackEmail ?? '',
      name: (metadata?['name'] as String?) ?? fallbackName ?? 'User',
      bio: '',
      gender: 'Other',
      createdAt: DateTime.now(),
    );
    await supabase.from('profiles').insert(profile.toJson());
  }

  static Future<void> signIn(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      logger.e("AuthService: signIn: Error signing in user $email: $e");
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      logger.e("AuthService: signOut: Error signing out user: $e");
      rethrow;
    }
  }

  static Future<bool> signUp(ProfileDataUpload newUser) async {
    try {
      await supabase.auth.signUp(
        email: newUser.email,
        password: newUser.password,
      );
      await supabase.auth.signInWithPassword(
        email: newUser.email,
        password: newUser.password,
      );

      final user = supabase.auth.currentUser;
      if (user == null) {
        logger.e('AuthService: signUp: currentUser is null after sign up');
        return false;
      }

      final existing = await supabase
          .from('profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      if (existing == null) {
        final prof = Profile(
          id: user.id,
          email: newUser.email,
          name: newUser.name,
          bio: newUser.bio,
          gender: newUser.gender,
        );
        await supabase.from('profiles').insert(prof.toJson());
      }

      logger.d(
        'AuthService: signUp: Signed up user ${newUser.email} with id ${user.id}',
      );
      return true;
    } catch (e) {
      logger.e(
        "AuthService: signUp: Error signing up user ${newUser.email}: $e",
      );
      return false;
    }
  }

  /// Sign in with Google
  static Future<bool> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        await supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo: Uri.base.origin,
        );
        return true;
      }

      final signIn = await _buildGoogleSignIn();
      final account = await signIn.authenticate();
      final idToken = account.authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        logger.w('AuthService: signInWithGoogle: Missing idToken');
        return false;
      }

      final authorization =
          await account.authorizationClient.authorizationForScopes([
            'email',
            'profile',
          ]) ??
          await account.authorizationClient.authorizeScopes([
            'email',
            'profile',
          ]);

      final result = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: authorization.accessToken,
      );

      final user = result.user;
      if (user == null) return false;

      await _ensureProfileExists(
        user,
        fallbackEmail: account.email,
        fallbackName: account.displayName,
      );

      return true;
    } catch (e) {
      final errorText = e.toString().toLowerCase();
      if (errorText.contains('cancel')) {
        logger.w('AuthService: signInWithGoogle: Cancelled by user');
        return false;
      }
      logger.e("AuthService: signInWithGoogle: Error: $e");
      rethrow;
    }
  }

  static Future<bool> signUpWithGoogle() async {
    return signInWithGoogle();
  }

  /// Sign out from Google and Supabase
  static Future<void> signOutGoogle() async {
    try {
      if (!kIsWeb) {
        final signIn = await _buildGoogleSignIn();
        await signIn.signOut();
      }
      await signOut();
    } catch (e) {
      logger.e("AuthService: signOutGoogle: Error: $e");
      rethrow;
    }
  }
}
