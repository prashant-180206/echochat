import 'package:flutter/material.dart';

class DiscoverTab extends StatelessWidget {
  const DiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Discover Tab",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}