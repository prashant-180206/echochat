import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
sealed class Profile with _$Profile {
  factory Profile({
    required String id,
    required String email,
    @Default('') String name,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @Default('') String bio,
    @Default('') String gender,
    @JsonKey(name: 'avatar_url') @Default('') String avatarUrl,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
