import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/profile.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<void> signIn(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<Profile> getProfile() async{
    final data  =await  supabase.from("profiles").select().eq("id", supabase.auth.currentUser!.id);
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
      await supabase.from("profiles").insert({
        "id": supabase.auth.currentUser!.id,
        "email": newUser.email,
        "bio": newUser.bio,
        "gender": newUser.gender,
        "name": newUser.name,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
