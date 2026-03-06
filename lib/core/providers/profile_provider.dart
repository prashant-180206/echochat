import 'package:echochat/core/models/profile.dart';
import 'package:echochat/core/services/profile_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileProvider extends _$ProfileProvider {
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
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refreshProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await ProfileService.getUserProfile();
      state = AsyncValue.data(profile);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}