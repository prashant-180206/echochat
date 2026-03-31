import 'package:echochat/core/models/message.dart';
import 'package:echochat/utils/time_formatter.dart';
import 'package:flutter/material.dart';

class TextContent extends StatelessWidget {
  final bool isMe;
  final Message message;

  const TextContent({super.key, required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bubbleColor = isMe
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;

    final textColor = isMe ? colorScheme.onPrimary : colorScheme.onSurface;
    final timeColor = isMe ? colorScheme.inversePrimary : colorScheme.secondary;

    final maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),

          // ✅ EXTRA bottom padding to avoid overlap
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),

          decoration: BoxDecoration(
            color: bubbleColor,

            // ✅ Directional bubble radius
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.edited)
                Text(
                  "Edited",
                  style: textTheme.labelSmall?.copyWith(color: timeColor),
                ),

              Text(
                message.content,
                style: textTheme.bodyMedium?.copyWith(color: textColor),
              ),

              const SizedBox(height: 4),

              Text(
                formatTime(message.createdAt),
                style: textTheme.bodySmall?.copyWith(color: timeColor),
              ),
            ],
          ),
        ),

        // ✅ Reaction (now safe, no overlap)
        if (message.reaction != null)
          Positioned(
            bottom: -16,
            right: isMe ? 0 : null,
            left: isMe ? null : 0,
            child: _buildReactionBadge(context, message.reaction!),
          ),
      ],
    );
  }

  Widget _buildReactionBadge(BuildContext context, String reaction) {
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = isMe
        ? colorScheme.primaryContainer
        : colorScheme.secondaryContainer;

    final textColor = isMe
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSecondaryContainer;

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(reaction, style: TextStyle(fontSize: 16, color: textColor)),
      ),
    );
  }
}
