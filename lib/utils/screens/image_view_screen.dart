import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  final String imageUrl;
  const ImageViewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image View')),
      body: Center(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          width: double.infinity,
          height: double.infinity,
          child: InteractiveViewer(
            child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
