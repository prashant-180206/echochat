import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/singleton.dart';

class DiscoverService {
  static Future<List<Profile>> fetchUsers(String searchStr) async {
    final currentUserId = supabase.auth.currentUser!.id;

    final response = await supabase
        .from("profiles")
        .select()
        .ilike("name", "%$searchStr%")
        .neq("id", currentUserId)
        .limit(20);

    return response.map<Profile>((res) => Profile.fromJson(res)).toList();
  }


  static Future<Profile> fetchUserById(String id) async {
    final response = await supabase.from("profiles").select().eq("id", id);
    return Profile.fromJson(response[0]);
  }
}
