
import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/singleton.dart';

class ProfileService {
  static Future<Profile> getUserProfile() async {
    try {
      final data = await supabase
          .from("profiles")
          .select()
          .eq("id", supabase.auth.currentUser!.id);

      logger.d(
        "ProfileService: getUserProfile: Fetched profile for user ${supabase.auth.currentUser!.email}",
      );
      return Profile.fromJson(data[0]);
    } catch (e) {
      logger.e(
        "ProfileService: getUserProfile: Error fetching profile for user ${supabase.auth.currentUser!.email}: $e",
      );
      rethrow;
    }
  }

  static Future<void> updateUserProfile(Profile updatedProfile) async {
    try {
      await supabase
          .from("profiles")
          .update(updatedProfile.toJson())
          .eq("id", supabase.auth.currentUser!.id);

    } catch (e) {
      logger.e(
        "ProfileService: updateUserProfile: Error updating profile for user ${supabase.auth.currentUser!.email}: $e",
      );
      rethrow;
    }
  }

  static Future<Profile> getUserProfilewithId(String userId) async {
    try {
      final data = await supabase.from("profiles").select().eq("id", userId);

      logger.d(
        "ProfileService: getUserProfilewithId: Fetched profile for user $userId",
      );
      return Profile.fromJson(data[0]);
    } catch (e) {
      logger.e(
        "ProfileService: getUserProfilewithId: Error fetching profile for user $userId: $e",
      );
      rethrow;
    }
  }
}
