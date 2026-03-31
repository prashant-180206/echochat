import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/services/message_service.dart';
import 'package:echochat/core/singleton.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_provider.g.dart';

/// Realtime messages (recent updates)
@riverpod
Stream<List<Message>> dynamicMessages(Ref ref, int conversationId) {
  return MessageService.streamMessagesForConversation(conversationId);
}

/// Message history with pagination
@riverpod
class MessageHistory extends _$MessageHistory {
  DateTime? _oldestMessageTime;
  bool _hasMore = true;

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
    if (_oldestMessageTime == null || !state.hasValue || !_hasMore) return;

    final currentMessages = state.value!;

    logger.d(
      "Loading more messages... Oldest time: $_oldestMessageTime, Current count: ${currentMessages.length}",
    );

    final result = await MessageService.getNextMessages(
      conversationId: conversationId,
      oldestMessageTime: _oldestMessageTime!,
    );

    if (result.isEmpty) {
      logger.i("No more messages to load.");
      _hasMore = false;
      return;
    }

    _oldestMessageTime = result.first.createdAt;

    state = AsyncValue.data([...result, ...currentMessages]);
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
