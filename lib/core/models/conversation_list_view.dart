import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_list_view.freezed.dart';
part 'conversation_list_view.g.dart';

@freezed
sealed class ConversationListView with _$ConversationListView {
  const factory ConversationListView({
    @JsonKey(name: 'conversation_id') required int conversationId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required int unread,
    @JsonKey(name: 'last_time') required DateTime lastTime,

    @JsonKey(name: 'message_id') int? messageId,
    String? content,
    @JsonKey(name: 'sender_id') String? senderId,
    @JsonKey(name: 'message_created_at') DateTime? messageCreatedAt,

    @JsonKey(name: 'other_user_id') required String otherUserId,
    required String name,
    required String email,
    @JsonKey(name: 'avatar_url') required String avatarUrl,
  }) = _ConversationListView;

  factory ConversationListView.fromJson(Map<String, dynamic> json) =>
      _$ConversationListViewFromJson(json);
}