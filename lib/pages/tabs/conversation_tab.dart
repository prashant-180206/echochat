import 'package:echochat/core/providers/conversation_provider.dart';
import 'package:echochat/pages/tabs/widgets/conversation_tile.dart';
import 'package:echochat/pages/tabs/widgets/error_display.dart';
import 'package:echochat/pages/tabs/widgets/list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConversationTab extends HookConsumerWidget {
  const ConversationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dynamicConvos = ref.watch(dynamicConversationsProvider);
    final staticConvos = ref.watch(staticConversationsProvider);

    final scrollcontroller = useScrollController();

    useEffect(() {
      void listener() {
        if (scrollcontroller.position.pixels >=
            scrollcontroller.position.maxScrollExtent - 200) {
          ref.read(staticConversationsProvider.notifier).loadMore();
        }
      }

      scrollcontroller.addListener(listener);
      return () => scrollcontroller.removeListener(listener);
    }, [scrollcontroller]);

    return dynamicConvos.when(
      data: (dynamicData) {
        return staticConvos.when(
          data: (staticData) {
            final allConvos = [...dynamicData, ...staticData];

            return ListView.separated(
              controller: scrollcontroller,
              itemCount: allConvos.length,
              itemBuilder: (context, index) =>
                  ConversationTile(conversation: allConvos[index]),

                  separatorBuilder: (context, index) => const Divider(height: 1 , indent: 20,endIndent: 20,),
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
