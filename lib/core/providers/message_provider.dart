import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/services/message_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_provider.g.dart';

/// Realtime messages (recent updates)
@riverpod
Stream<List<Message>> dynamicMessages(
  Ref ref,
  int conversationId,
) {
  return MessageService.streamMessagesForConversation(conversationId);
}

/// Message history with pagination
@riverpod
class MessageHistory extends _$MessageHistory {
  DateTime? _oldestMessageTime;

  @override
  Future<List<Message>> build(int conversationId) async {
    final messages = await MessageService.getInitialMessagesForConversation(
      conversationId,
    );

    if (messages.isNotEmpty) {
      _oldestMessageTime = messages.first.createdAt;
    }

    return messages;
  }

  /// load older messages
  Future<void> loadMore() async {
    if (_oldestMessageTime == null || !state.hasValue) return;

    final currentMessages = state.value!;

    final result = await MessageService.getNextMessages(
      conversationId: conversationId,
      oldestMessageTime: _oldestMessageTime!,
    );

    if (result.isEmpty) return;

    _oldestMessageTime = result.first.createdAt;

    state = AsyncValue.data([
      ...result,
      ...currentMessages,
    ]);
  }

  /// send message
  Future<void> send(String content, {String type = "text"}) async {
    await MessageService.sendMessage(
      conversationId: conversationId,
      content: content,
      type: type,
    );
  }

  /// edit message
  Future<void> edit(int messageId, String newContent) async {
    await MessageService.editMessage(messageId, newContent);
  }

  /// delete message
  Future<void> delete(int messageId) async {
    await MessageService.deleteMessage(messageId);
  }

  /// refresh history
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    final messages = await MessageService.getInitialMessagesForConversation(
      conversationId,
    );

    if (messages.isNotEmpty) {
      _oldestMessageTime = messages.first.createdAt;
    }

    state = AsyncValue.data(messages);
  }
}