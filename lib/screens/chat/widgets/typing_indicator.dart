import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({
    super.key,
    required this.isVisible,
    required this.userName,
  });

  final bool isVisible;
  final String userName;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '$userName is typing...',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
