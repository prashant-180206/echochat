// import 'package:echochat/core/services/discover_service.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:echochat/core/models/profile.dart';

// part 'discover_provider.g.dart';

// @riverpod
// Future<List<Profile>> discoverUsers(
//   WidgetRef ref,
//   String searchStr,
// ) async {
//   if (searchStr.trim().isEmpty) {
//     return [];
//   }

//   return DiscoverService.fetchUsers(searchStr.trim());
// }