import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MessageInput extends HookWidget {
  final Function(String) onSendPressed;
  final Function() onImageSendPressed;
  final ValueChanged<String>? onTextChanged;
  final VoidCallback? onTypingStopped;

  const MessageInput({
    super.key,
    required this.onSendPressed,
    required this.onImageSendPressed,
    this.onTextChanged,
    this.onTypingStopped,
  });

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                onTypingStopped?.call();
                onImageSendPressed();
              },
              icon: const Icon(Icons.image),
              color: colorScheme.onSurfaceVariant,
            ),

            Expanded(
              child: Container(
                // padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceDim,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller,
                  onChanged: onTextChanged,
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
                onSendPressed(controller.text.trim());
                controller.clear();
                onTypingStopped?.call();
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

class MessageEditInput extends HookWidget {
  final String initialText;
  final Function(String) onEditCompleted;
  final Function() onEditCancel;

  const MessageEditInput({
    super.key,
    required this.initialText,
    required this.onEditCompleted,
    required this.onEditCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final controller = useTextEditingController();
    controller.text = initialText;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              initialText,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => onEditCancel(),
                  icon: Icon(Icons.cancel),
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
                    onEditCompleted(controller.text.trim());
                    controller.clear();
                  },
                  icon: const Icon(Icons.send),
                  color: colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
