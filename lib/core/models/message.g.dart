// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: (json['id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  content: json['content'] as String? ?? '',
  type: json['type'] as String? ?? 'text',
  senderId: json['sender_id'] as String,
  conversationId: (json['conversation_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'content': instance.content,
  'type': instance.type,
  'sender_id': instance.senderId,
  'conversation_id': instance.conversationId,
};
