import 'package:cached_network_image/cached_network_image.dart';
import 'package:echochat/core/models/message.dart';
import 'package:echochat/utils/screens/image_view_screen.dart';
import 'package:flutter/material.dart';

class ImageContent extends StatelessWidget {
  final bool isMe;
  final Message message;

  const ImageContent({
    super.key,
    required this.isMe,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.65;

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ImageViewScreen(imageUrl: message.content),
                  ),
                );
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                  maxHeight: 250,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isMe
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1, // ✅ keeps image square & stable
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: message.content,
                      placeholder: (_, _) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (_, _, _) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),

            // ✅ Reaction Badge (floating)
            if (message.reaction != null)
              Positioned(
                bottom: -10,
                right: isMe ? 0 : null,
                left: isMe ? null : 0,
                child: _buildReactionBadge(context, message.reaction!),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildReactionBadge(BuildContext context, String reaction) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          reaction,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}