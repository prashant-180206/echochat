import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/services/message_service.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/utils/types.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popover/popover.dart';

class MessageActionsPopover {
  static final List<String> defaultReactions = [
    '👍',
    '❤️',
    '😂',
    '😮',
    '😢',
    '🔥',
  ];

  /// Shows a popover with reaction options and action buttons
  static void show({
    required BuildContext context,
    required Message message,
    required Function(int) onMessageDeleted,
    required Function(int) onEditMessagePressed,
  }) {
    final isMe = message.senderId == supabase.auth.currentUser?.id;

    showPopover(
      direction: PopoverDirection.top,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      context: context,
      bodyBuilder: (_) => _buildPopoverContent(
        context: context,
        message: message,
        isMe: isMe,
        onMessageDeleted: onMessageDeleted,
        onEditMessagePressed: onEditMessagePressed,
      ),
    );
  }

  static Widget _buildPopoverContent({
    required BuildContext context,
    required Message message,
    required bool isMe,
    required Function(int) onMessageDeleted,
    required Function(int) onEditMessagePressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Reactions section (only for messages from others)
        if (!isMe)
          _buildReactionsRow(context: context, message: message),

        if (!isMe) const Divider(),

        // Actions section
        _buildActionsRow(
          context: context,
          message: message,
          isMe: isMe,
          onMessageDeleted: onMessageDeleted,
          onEditMessagePressed: onEditMessagePressed,
        ),
      ],
    );
  }

  static Widget _buildReactionsRow({
    required BuildContext context,
    required Message message,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...defaultReactions.map((emoji) {
          return _buildReactionButton(
            context: context,
            emoji: emoji,
            message: message,
          );
        }),
        // Emoji picker button
        IconButton(
          icon: const Icon(Icons.add_reaction_outlined),
          onPressed: () {
            Navigator.pop(context);
            _showEmojiPicker(context, message);
          },
        ),
      ],
    );
  }

  static Widget _buildReactionButton({
    required BuildContext context,
    required String emoji,
    required Message message,
  }) {
    return InkWell(
      onTap: () async {
        final isSame = message.reaction == emoji;

        if (isSame) {
          await MessageService.removeReaction(message.id);
        } else {
          await MessageService.setReaction(
            messageId: message.id,
            reaction: emoji,
          );
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isSame ? 'Reaction removed' : 'Reacted with $emoji',
              ),
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }

  static Widget _buildActionsRow({
    required BuildContext context,
    required Message message,
    required bool isMe,
    required Function(int) onMessageDeleted,
    required Function(int) onEditMessagePressed,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Copy button
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: message.content));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Message copied')),
            );
            Navigator.pop(context);
          },
        ),
        // Delete button
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            await MessageService.deleteMessage(message.id);
            onMessageDeleted(message.id);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message deleted')),
              );
              Navigator.pop(context);
            }
          },
        ),
        // Edit button (only for text messages)
        if (message.type == MessageType.text)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              onEditMessagePressed(message.id);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }

  static void _showEmojiPicker(BuildContext context, Message message) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 300,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) async {
              final isSame = message.reaction == emoji.emoji;

              if (isSame) {
                await MessageService.removeReaction(message.id);
              } else {
                await MessageService.setReaction(
                  messageId: message.id,
                  reaction: emoji.emoji,
                );
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isSame
                          ? 'Reaction removed'
                          : 'Reacted with ${emoji.emoji}',
                    ),
                  ),
                );
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }
}
