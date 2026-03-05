// import 'package:echochat/providers/conversation_provider.dart';
import 'package:echochat/core/providers/conversation_provider.dart';
import 'package:echochat/pages/tabs/widgets/conversation_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationTab extends ConsumerWidget {
  const ConversationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dynamicConvos = ref.watch(dynamicConversationsProvider);
    final staticConvos = ref.watch(staticConversationsProvider);

    return staticConvos.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
      data: (staticList) {
        final dynamicList = dynamicConvos.value ?? [];

        final conversations = [
          ...dynamicList,
          ...staticList,
        ];

        if (conversations.isEmpty) {
          return const Center(child: Text("No conversations"));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            /// Trigger when reaching the top
            if (scroll.metrics.pixels <= 0) {
              ref
                  .read(staticConversationsProvider.notifier)
                  .loadMore();
            }
            return false;
          },
          child: ListView(
            children: conversations
                .map(
                  (c) => ConversationTile(
                    conversation: c,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}