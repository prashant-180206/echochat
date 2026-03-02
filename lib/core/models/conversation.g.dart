// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Conversation _$ConversationFromJson(Map<String, dynamic> json) =>
    _Conversation(
      id: (json['id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      unread: (json['unread'] as num?)?.toInt() ?? 0,
      lastTime: json['last_time'] == null
          ? null
          : DateTime.parse(json['last_time'] as String),
      lastMessage: (json['last_message'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConversationToJson(_Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'unread': instance.unread,
      'last_time': instance.lastTime?.toIso8601String(),
      'last_message': instance.lastMessage,
    };
