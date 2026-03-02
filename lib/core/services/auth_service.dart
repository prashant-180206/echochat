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
  Future<void> signIn(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<Profile> getProfile() async {
    final data = await supabase
        .from("profiles")
        .select()
        .eq("id", supabase.auth.currentUser!.id);

    logger.d(
      "AuthService: getProfile: Fetched profile for user ${supabase.auth.currentUser!.email}",
    );
    return Profile.fromJson(data[0]);
  }

  Future<bool> signUp(ProfileDataUpload newUser) async {
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
