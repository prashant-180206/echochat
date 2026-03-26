import 'package:echochat/utils/types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
sealed class Message with _$Message {
  factory Message({
    required int id,

    @JsonKey(name: 'created_at') required DateTime createdAt,

    @Default('') String content,

    @Default(MessageType.text) MessageType type,

    @JsonKey(name: 'sender_id') required String senderId,

    @Default(false) bool edited ,

    @JsonKey(name: 'conversation_id') int? conversationId,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
