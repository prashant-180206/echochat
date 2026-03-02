import 'package:echochat/data/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiscoverService {
  final supabase = Supabase.instance.client;

  Future<List<Profile>> fetchUsers(String searchstr) async {
    final response = await supabase
        .from("profiles")
        .select()
        .ilike("name", "%$searchstr%");
    List<Profile> searchresults = [];
    for (var res in response) {
      Profile p = Profile.fromJson(res);
      searchresults.add(p);
    }
    return searchresults;
  }
}
