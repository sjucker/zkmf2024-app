import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<Widget>? homeAction(BuildContext context) {
  if (!context.canPop()) {
    return [
      IconButton(
        icon: const Icon(Icons.home),
        tooltip: 'Home',
        onPressed: () {
          context.go('/');
        },
      ),
    ];
  }
  return null;
}
