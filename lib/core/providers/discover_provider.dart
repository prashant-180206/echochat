import 'package:echochat/core/services/discover_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:echochat/core/models/profile.dart';

part 'discover_provider.g.dart';

@riverpod
Future<List<Profile>> discover(
  Ref ref,
  String searchStr,
) async {
  if (searchStr.isEmpty) return [];
  return DiscoverService.fetchUsers(searchStr);
}