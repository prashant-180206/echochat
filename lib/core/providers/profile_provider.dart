import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/services/profile_service.dart';
import 'package:echochat/core/singleton.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileInstance extends _$ProfileInstance {
  @override
  FutureOr<Profile> build() {
    return ProfileService.getUserProfile();
  }

  Future<void> updateProfile(Profile updatedProfile) async {
    state = const AsyncValue.loading();
    try {
      await ProfileService.updateUserProfile(updatedProfile);
      state = AsyncValue.data(updatedProfile);
    } catch (e) {
      logger.e("Failed to update profile: $e");
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await ProfileService.getUserProfile();
      state = AsyncValue.data(profile);
    } catch (e) {
      logger.e("Failed to refresh profile: $e");
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

@riverpod
FutureOr<Profile> profileWithId(Ref ref, String id) async {
  return await ProfileService.getUserProfilewithId(id);
}
