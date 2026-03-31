import 'package:echochat/utils/types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
sealed class ConversationMember with _$ConversationMember {
  factory ConversationMember({
    required String id,
    required String name,
    @JsonKey(name: 'avatar_url') @Default('') String avatarUrl,
  }) = _ConversationMember;

  factory ConversationMember.fromJson(Map<String, dynamic> json) =>
      _$ConversationMemberFromJson(json);
}

@freezed
sealed class Conversation with _$Conversation {
  factory Conversation({
    required int id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(0) int unread,
    @JsonKey(name: 'last_time') DateTime? lastTime,
    @JsonKey(name: 'last_message') int? lastMessage,
    @JsonKey(name: 'last_message_content')
    @Default('')
    String lastMessageContent,
    @JsonKey(name: 'last_message_type') @Default(MessageType.text) MessageType lastMessageType,
    @JsonKey(name: 'last_message_sender_id') String? lastMessageSenderId,

    // NEW: The list of members
    @Default([]) List<ConversationMember> members,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}
