// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_list_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationListView _$ConversationListViewFromJson(
  Map<String, dynamic> json,
) => _ConversationListView(
  conversationId: (json['conversation_id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  unread: (json['unread'] as num).toInt(),
  lastTime: DateTime.parse(json['last_time'] as String),
  messageId: (json['message_id'] as num?)?.toInt(),
  content: json['content'] as String?,
  senderId: json['sender_id'] as String?,
  messageCreatedAt: json['message_created_at'] == null
      ? null
      : DateTime.parse(json['message_created_at'] as String),
  otherUserId: json['other_user_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  avatarUrl: json['avatar_url'] as String,
);

Map<String, dynamic> _$ConversationListViewToJson(
  _ConversationListView instance,
) => <String, dynamic>{
  'conversation_id': instance.conversationId,
  'created_at': instance.createdAt.toIso8601String(),
  'unread': instance.unread,
  'last_time': instance.lastTime.toIso8601String(),
  'message_id': instance.messageId,
  'content': instance.content,
  'sender_id': instance.senderId,
  'message_created_at': instance.messageCreatedAt?.toIso8601String(),
  'other_user_id': instance.otherUserId,
  'name': instance.name,
  'email': instance.email,
  'avatar_url': instance.avatarUrl,
};
