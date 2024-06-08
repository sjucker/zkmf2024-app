import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GeneralErrorWidget extends StatelessWidget {
  const GeneralErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        '😵 da ist was schiefgelaufen...',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      FilledButton(
        onPressed: () => {context.go('/')},
        child: const Text("zurück"),
      )
    ]));
  }
}
