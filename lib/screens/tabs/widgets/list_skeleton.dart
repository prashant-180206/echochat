import 'package:flutter/cupertino.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonListView(
      itemCount: 8,
      itemBuilder: (p0, p1) {
        return SkeletonListTile(
          leadingStyle: SkeletonAvatarStyle(
            width: 50,
            height: 50,
            shape: BoxShape.circle,
          ),
          hasSubtitle: true,
          titleStyle: SkeletonLineStyle(
            height: 15,
            width: 250,

            borderRadius: BorderRadius.circular(8),
          ),
          subtitleStyle: SkeletonLineStyle(
            height: 14,

            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}
