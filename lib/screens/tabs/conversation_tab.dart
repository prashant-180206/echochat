import 'package:echochat/core/providers/conversation_provider.dart';
import 'package:echochat/screens/tabs/widgets/conversation_tile.dart';
import 'package:echochat/screens/tabs/widgets/list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConversationTab extends HookConsumerWidget {
  const ConversationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dynamicConvos = ref.watch(dynamicConversationsProvider);
    final staticConvos = ref.watch(staticConversationsProvider);

    final scrollController = useScrollController();

    // ⚡ TEMP: assume loadingMore based on provider state
    // (replace later with proper state if you add it)
    final isLoadingMore = useState(false);

    useEffect(() {
      void listener() {
        if (!scrollController.hasClients) return;

        final threshold = 200;
        final max = scrollController.position.maxScrollExtent;
        final current = scrollController.position.pixels;

        if (current >= max - threshold && !isLoadingMore.value) {
          isLoadingMore.value = true;

          ref
              .read(staticConversationsProvider.notifier)
              .loadMore()
              .whenComplete(() {
                isLoadingMore.value = false;
              });
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController]);

    final combined = dynamicConvos.when(
      data: (dynamicData) => staticConvos.when(
        data: (staticData) {
          final map = {
            for (final c in staticData) c.id: c,
            for (final c in dynamicData) c.id: c,
          };

          final list = map.values.toList()
            ..sort(
              (a, b) => (b.lastTime ?? DateTime(0)).compareTo(
                a.lastTime ?? DateTime(0),
              ),
            );

          return list;
        },
        loading: () => null,
        error: (_, _) => null,
      ),
      loading: () => null,
      error: (_, _) => null,
    );

    if (combined == null) {
      return const ListSkeleton();
    }

    if (combined.isEmpty) {
      return const Center(
        child: Text("No conversations yet", style: TextStyle(fontSize: 16)),
      );
    }

    final showLoader = isLoadingMore.value;

    return ListView.separated(
      controller: scrollController,
      itemCount: combined.length + (showLoader ? 1 : 0),

      itemBuilder: (context, index) {
        if (index == combined.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return ConversationTile(conversation: combined[index]);
      },

      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 20, endIndent: 20),
    );
  }
}
