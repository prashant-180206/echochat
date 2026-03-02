// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String? ?? '',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  bio: json['bio'] as String? ?? '',
  gender: json['gender'] as String? ?? '',
  avatarUrl: json['avatarUrl'] as String? ?? '',
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'createdAt': instance.createdAt?.toIso8601String(),
  'bio': instance.bio,
  'gender': instance.gender,
  'avatarUrl': instance.avatarUrl,
};
