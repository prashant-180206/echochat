import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
sealed class Conversation with _$Conversation {
  factory Conversation({
    required int id,

    @JsonKey(name: 'created_at')
    required DateTime createdAt,

    @Default(0)
    int unread,

    @JsonKey(name: 'last_time')
    DateTime? lastTime,

    @JsonKey(name: 'last_message')
    int? lastMessage,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}