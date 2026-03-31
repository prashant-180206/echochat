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

    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha((255 * 0.9).toInt()),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

              Center(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  child: InteractiveViewer(
                    child: Image.network(avatarUrl, fit: BoxFit.contain),
                  ),
                ),
              ),

              Positioned(
                top: 40,
                right: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAvatarDialog(context),

      child: CircleAvatar(
        radius: size / 2,
        child: avatarUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: avatarUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
