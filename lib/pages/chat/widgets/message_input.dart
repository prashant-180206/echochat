import 'package:echochat/core/services/message_service.dart';
import 'package:echochat/core/singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageInput extends HookConsumerWidget {
  final int conversationId;

  const MessageInput({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final controller = useTextEditingController();
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.attach_file),
              color: colorScheme.onSurfaceVariant,
            ),

            Expanded(
              child: Container(
                // padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceDim,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  style: textTheme.bodyMedium?.copyWith(
                    // color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: "Message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            IconButton(
              iconSize: 28,
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) return;

                logger.d("Send button pressed with message: $text");

                MessageService.sendMessage(
                  conversationId: conversationId,
                  content: text,
                );

                controller.clear();
              },
              icon: const Icon(Icons.send),
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
