import 'package:flutter/material.dart';

class ConversationTab extends StatelessWidget {
  const ConversationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Conversation Tab",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}