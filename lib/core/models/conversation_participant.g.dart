// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationParticipant _$ConversationParticipantFromJson(
  Map<String, dynamic> json,
) => _ConversationParticipant(
  userId: json['user_id'] as String,
  conversationId: (json['conversation_id'] as num).toInt(),
);

Map<String, dynamic> _$ConversationParticipantToJson(
  _ConversationParticipant instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'conversation_id': instance.conversationId,
};
