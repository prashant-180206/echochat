import 'package:echochat/core/providers/conversation_provider.dart';
import 'package:echochat/pages/tabs/widgets/conversation_tile.dart';
import 'package:echochat/pages/tabs/widgets/error_display.dart';
import 'package:echochat/pages/tabs/widgets/list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationTab extends ConsumerWidget {
  const ConversationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dynamicConvos = ref.watch(dynamicConversationsProvider);
    final staticConvos = ref.watch(staticConversationsProvider);

    return dynamicConvos.when(
      data: (dynamicData) {
        return staticConvos.when(
          data: (staticData) {
            final allConvos = [...dynamicData, ...staticData];

            return ListView.builder(
              itemCount: allConvos.length,
              itemBuilder: (context, index) =>
                  ConversationTile(conversation: allConvos[index]),
            );
          },
          loading: () => const ListSkeleton(),
          error: (e, s) => ErrorDisplay(error: e, stackTrace: s),
        );
      },
      loading: () => const ListSkeleton(),
      error: (e, s) => ErrorDisplay(error: e, stackTrace: s),
    );
  }
}
