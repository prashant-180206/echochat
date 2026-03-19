import 'package:echochat/core/models/conversation.dart';
import 'package:echochat/core/services/conversation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_provider.g.dart';

/// REALTIME conversations (last 10 minutes)
@Riverpod(keepAlive: true)
Stream<List<Conversation>> dynamicConversations(
  Ref ref,
) {
  return ConversationService.streamConversations();
}

/// STATIC conversations (older than 10 minutes) with pagination
@Riverpod(keepAlive: true)
class StaticConversations extends _$StaticConversations {
  DateTime? _lastTime;

  @override
  Future<List<Conversation>> build() async {
    final result = await ConversationService.getInitialConversations();

    if (result.isNotEmpty) {
      _lastTime = result.last.lastTime;
    }

    return result;
  }

  /// pagination
  Future<void> loadMore() async {
    if (_lastTime == null || !state.hasValue) return;

    final currentList = state.value!;

    final result = await ConversationService.getMoreConversations(
      lastFetchedTime: _lastTime!,
    );

    if (result.isEmpty) return;

    _lastTime = result.last.lastTime;

    state = AsyncValue.data([
      ...currentList,
      ...result,
    ]);
  }
}