import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class MessageSkeleton extends StatelessWidget {
  final bool isMe;

  const MessageSkeleton({super.key, this.isMe = false});

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: 220,
              height: 60,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 12,
                      width: double.infinity,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 6),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 12,
                      width: 180,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}