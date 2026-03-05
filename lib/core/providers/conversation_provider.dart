import 'package:echochat/core/models/conversation_list_view.dart';
import 'package:echochat/core/services/conversation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_provider.g.dart';

/// REALTIME conversations (last 10 minutes)
@riverpod
Stream<List<ConversationListView>> dynamicConversations(
  Ref ref,
) {
  return ConversationService.streamRecentChanges();
}

/// STATIC conversations (older than 10 minutes) with pagination
@riverpod
class StaticConversations extends _$StaticConversations {
  DateTime? _lastTime;

  @override
  Future<List<ConversationListView>> build() async {
    final result = await ConversationService.getStaticConversations();

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
      lastFetchedLastTime: _lastTime!,
    );

    if (result.isEmpty) return;

    _lastTime = result.last.lastTime;

    state = AsyncValue.data([
      ...currentList,
      ...result,
    ]);
  }

  /// refresh static list
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    final result = await ConversationService.getStaticConversations();

    if (result.isNotEmpty) {
      _lastTime = result.last.lastTime;
    }

    state = AsyncValue.data(result);
  }
}