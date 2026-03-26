import 'package:cached_network_image/cached_network_image.dart';
import 'package:echochat/core/models/message.dart';
import 'package:echochat/core/services/message_service.dart';
import 'package:echochat/core/singleton.dart';
import 'package:echochat/utils/screens/image_view_screen.dart';
import 'package:echochat/utils/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';

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

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Builder(
          builder: (bubbleContext) {
            return InkWell(
              onLongPress: () {
                _handleSelection(bubbleContext); // ✅ IMPORTANT
              },
              child: _getMessageContent(context, isMe),
            );
          },
        ),
      ),
    );
  }

  void _handleSelection(BuildContext context) {
    showPopover(
      direction: PopoverDirection.top,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      context: context,
      bodyBuilder: (_) => Container(
        // color: Theme.of(context).colorScheme.surfaceContainerHigh,
        padding: EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Message copied to clipboard')),
                );
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await MessageService.deleteMessage(message.id);
                onMessageDeleted(message.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Message deleted')));
                  Navigator.pop(context);
                }
              },
            ),
            message.type == MessageType.text
                ? IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      onEditMessagePressed(message.id);
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _getMessageContent(BuildContext context, bool isMe) {
    switch (message.type) {
      case MessageType.text:
        return TextContent(isMe: isMe, message: message);
      case MessageType.image:
        return ImageContent(isMe: isMe, message: message);
      // case MessageType.file:
      //   return FileContent(message: message);
      default:
        return const SizedBox.shrink();
    }
  }
}

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
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      // margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(12.0),
      ),

      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          message.edited
              ? Text(
                  "Edited",
                  style: textTheme.labelSmall?.copyWith(color: timeColor),
                )
              : const SizedBox.shrink(),
          Text(
            message.content,
            style: textTheme.bodyMedium?.copyWith(color: textColor),
          ),

          const SizedBox(height: 4.0),

          Text(
            formatTime(message.createdAt),
            style: textTheme.bodySmall?.copyWith(color: timeColor),
          ),
        ],
      ),
    );
  }
}

class ImageContent extends StatelessWidget {
  final bool isMe;
  final Message message;
  const ImageContent({super.key, required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewScreen(imageUrl: message.content),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: 200,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isMe
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            width: 4,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: isMe
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          width: 200,
          height: 200,
          child: CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl: message.content,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}

String formatTime(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24 && now.day == time.day) {
    return '${difference.inHours} hr ago';
  } else if (difference.inDays == 1 && now.day - time.day == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return DateFormat('EEE').format(time);
  } else {
    return DateFormat('dd/MM/yyyy').format(time);
  }
}
