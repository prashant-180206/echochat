import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_participant.freezed.dart';
part 'conversation_participant.g.dart';

@freezed
sealed class ConversationParticipant with _$ConversationParticipant {
  factory ConversationParticipant({
    @JsonKey(name: 'user_id')
    required String userId,

    @JsonKey(name: 'conversation_id')
    required int conversationId,
  }) = _ConversationParticipant;

  factory ConversationParticipant.fromJson(Map<String, dynamic> json) =>
      _$ConversationParticipantFromJson(json);
}