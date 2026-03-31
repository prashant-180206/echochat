import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ImageViewScreen extends HookWidget {
  final String imageUrl;

  const ImageViewScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final controller = useTransformationController();
    final showUI = useState(true);

    void handleDoubleTap(TapDownDetails details) {
      final position = details.localPosition;
      final zoomed = controller.value != Matrix4.identity();

      if (zoomed) {
        controller.value = Matrix4.identity();
      } else {
        const zoom = 3.0;

        controller.value = Matrix4.identity()
          ..translateByDouble(
            -position.dx * (zoom - 1),
            -position.dy * (zoom - 1),
            0,
            1,
          )
          ..scaleByDouble(zoom, zoom, 1, 1);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: showUI.value
          ? AppBar(
              backgroundColor: Colors.black.withAlpha(140),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            )
          : null,

      body: GestureDetector(
        onTap: () => showUI.value = !showUI.value,
        onDoubleTapDown: handleDoubleTap,

        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return InteractiveViewer(
                transformationController: controller,
                minScale: 1,
                maxScale: 5,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Hero(
                        tag: imageUrl,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,

                          placeholder: (_, _) => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),

                          errorWidget: (_, _, _) => const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
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
    );
  }
}
