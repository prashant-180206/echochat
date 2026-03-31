import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/screens/chat/widgets/message_bubble/image_content.dart';
import 'package:echochat/screens/chat/widgets/message_bubble/message_actions.dart';
import 'package:echochat/screens/chat/widgets/message_bubble/text_content.dart';
import 'package:flutter/material.dart';
import 'package:echochat/utils/types.dart';

/// Main message bubble widget that displays chat messages.
///
/// Supports both text and image messages with reactions and actions.
/// Long-press to access reactions, copy, edit, or delete options.
class MessageBubble extends StatelessWidget {
  final Message message;
  final Function(int) onMessageDeleted;
  final Function(int) onEditMessagePressed;

  const MessageBubble({
    super.key,
    required this.message,
    required this.onMessageDeleted,
    required this.onEditMessagePressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.senderId == supabase.auth.currentUser?.id;
    final bool hasReaction = message.reaction != null;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        // padding: EdgeInsets.symmetric(vertical: (hasReaction ? 12 : 4), horizontal: 8.0),
        padding: EdgeInsets.only(
          bottom: hasReaction ? 18 : 4,
          top: 4,
          left: 8,
          right: 8,
        ),
        child: Builder(
          builder: (bubbleContext) {
            return InkWell(
              onLongPress: () => _handleLongPress(bubbleContext),
              child: _getMessageContent(context, isMe),
            );
          },
        ),
      ),
    );
  }

  /// Handles long-press to show actions popover
  void _handleLongPress(BuildContext context) {
    MessageActionsPopover.show(
      context: context,
      message: message,
      onMessageDeleted: onMessageDeleted,
      onEditMessagePressed: onEditMessagePressed,
    );
  }

  /// Returns the appropriate content widget based on message type
  Widget _getMessageContent(BuildContext context, bool isMe) {
    switch (message.type) {
      case MessageType.text:
        return TextContent(isMe: isMe, message: message);
      case MessageType.image:
        return ImageContent(isMe: isMe, message: message);
      default:
        return const SizedBox.shrink();
    }
  }
}
