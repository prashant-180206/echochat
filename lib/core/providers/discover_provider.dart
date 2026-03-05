import 'package:echochat/core/services/discover_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:echochat/core/models/profile.dart';

part 'discover_provider.g.dart';

@riverpod
class Discover extends _$Discover {

  @override
  Future<List<Profile>> build(String searchstr) async {
    await DiscoverService.fetchUsers(searchstr);
    return Future.value([]);
  }

  Future<void> changesearchstr(String newstr) async {
    state = const AsyncValue.loading();
    final result = await DiscoverService.fetchUsers(newstr);
    state = AsyncValue.data(result);
  }
}