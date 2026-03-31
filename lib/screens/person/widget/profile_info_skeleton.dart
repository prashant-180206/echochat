import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class PersonInfoSkeleton extends StatelessWidget {
  const PersonInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          /// Avatar
          const SkeletonAvatar(
            style: SkeletonAvatarStyle(
              shape: BoxShape.circle,
              width: 160,
              height: 160,
            ),
          ),

          const SizedBox(height: 16),

          /// Name
          const SkeletonLine(
            style: SkeletonLineStyle(
              height: 20,
              width: 150,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),

          const SizedBox(height: 8),

          /// Email
          const SkeletonLine(
            style: SkeletonLineStyle(
              height: 14,
              width: 200,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),

          const SizedBox(height: 24),

          /// Details Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                _ProfileTileSkeleton(),
                Divider(height: 1),
                _ProfileTileSkeleton(),
                Divider(height: 1),
                _ProfileTileSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTileSkeleton extends StatelessWidget {
  const _ProfileTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          /// Icon placeholder
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: 20,
              height: 20,
            ),
          ),

          SizedBox(width: 12),

          /// Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 12,
                    width: 80,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
                SizedBox(height: 6),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 16,
                    width: 150,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}