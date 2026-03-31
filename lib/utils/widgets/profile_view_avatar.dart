import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileViewAvatar extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final double size;

  const ProfileViewAvatar({
    super.key,
    required this.avatarUrl,
    required this.name,
    this.size = 40,
  });

  void _showAvatarDialog(BuildContext context) {
    if (avatarUrl.isEmpty) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, _, _) => _AvatarViewer(avatarUrl: avatarUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAvatarDialog(context),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: avatarUrl.isNotEmpty
            ? ClipOval(
                child: Hero(
                  tag: avatarUrl,
                  child: CachedNetworkImage(
                    imageUrl: avatarUrl,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => const SizedBox(),
                    errorWidget: (_, _, _) => const Icon(Icons.person),
                  ),
                ),
              )
            : Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
              ),
      ),
    );
  }
}

class _AvatarViewer extends StatelessWidget {
  final String avatarUrl;

  const _AvatarViewer({required this.avatarUrl});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(220),
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: avatarUrl,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return InteractiveViewer(
                    minScale: 1,
                    maxScale: 5,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: CachedNetworkImage(
                            imageUrl: avatarUrl,
                            fit: BoxFit.contain,
                            placeholder: (_, _) => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (_, _, _) => const Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
