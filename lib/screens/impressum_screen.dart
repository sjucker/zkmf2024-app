import 'package:flutter/material.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impressum'),
        actions: homeAction(context),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Verein \"zkmf2024\"",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text("Im Grüt 52"),
              Text("8902 Urdorf"),
            ],
          ),
        ),
      ),
    );
  }
}
