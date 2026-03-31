import 'package:echochat/core/providers/discover_provider.dart';
import 'package:echochat/screens/tabs/widgets/error_display.dart';
import 'package:echochat/screens/tabs/widgets/list_skeleton.dart';
import 'package:echochat/screens/tabs/widgets/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

class DiscoverTab extends HookConsumerWidget {
  const DiscoverTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final searchText = useState("");
    final isTyping = useState(false);

    final debouncer = useMemoized(() => Debouncer());

    // ✅ dispose debouncer
    useEffect(() {
      return debouncer.cancel;
    }, [debouncer]);

    final results = ref.watch(discoverProvider(searchText.value));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Search users",
              prefixIcon: const Icon(Icons.search),

              // ✅ clear button
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.clear();
                        searchText.value = "";
                      },
                    )
                  : null,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            onChanged: (value) {
              isTyping.value = true;

              debouncer.debounce(
                duration: const Duration(milliseconds: 400),
                onDebounce: () {
                  searchText.value = value.trim();
                  isTyping.value = false;
                },
              );
            },
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Builder(
              builder: (_) {
                // ✅ empty state (before typing)
                if (searchText.value.isEmpty) {
                  return const Center(
                    child: Text(
                      "Search for users",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // ✅ typing state (no flicker)
                if (isTyping.value) {
                  return const ListSkeleton();
                }

                return results.when(
                  data: (profiles) {
                    if (profiles.isEmpty) {
                      return const Center(
                        child: Text("No users found"),
                      );
                    }

                    return ListView.builder(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        return ProfileTile(
                          currentProfile: profiles[index],
                        );
                      },
                    );
                  },
                  loading: () => const ListSkeleton(),
                  error: (e, st) =>
                      ErrorDisplay(error: e, stackTrace: st),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}