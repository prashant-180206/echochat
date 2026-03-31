import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/singleton.dart';

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
      final prof = Profile(
        id: supabase.auth.currentUser!.id,
        email: newUser.email,
        name: newUser.name,
        bio: newUser.bio,
        gender: newUser.gender,
      );
      await supabase.from("profiles").insert(prof.toJson());
      logger.d(
        "AuthService: signUp: Signed up user ${newUser.email} with id ${prof.id}",
      );
      return true;
    } catch (e) {
      logger.e(
        "AuthService: signUp: Error signing up user ${newUser.email}: $e",
      );
      return false;
    }
  }
}
