import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/singleton.dart';

class DiscoverService {
  static Future<List<Profile>> fetchUsers(String searchstr) async {
    final response = await supabase
        .from("profiles")
        .select()
        .ilike("name", "%$searchstr%");
    List<Profile> searchresults = [];
    for (var res in response) {
      Profile p = Profile.fromJson(res);
      searchresults.add(p);
    }
    logger.d(
      "DiscoverService: fetchUsers: searchstr: $searchstr, results: ${searchresults.length}",
    );
    return searchresults;
  }

  static Future<Profile> fetchUserById(String id) async {
    final response = await supabase
        .from("profiles")
        .select()
        .eq("id", id);
    return Profile.fromJson(response[0]);
  }
}
