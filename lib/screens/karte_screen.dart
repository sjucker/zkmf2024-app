import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class KarteScreen extends StatelessWidget {
  const KarteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Karte Festareal"),
        actions: homeAction(context),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Schlieren"),
            onTap: () {
              context.push("/karte/schlieren");
            },
            trailing: const Icon(
              Icons.navigate_next_sharp,
            ),
          ),
          ListTile(
            title: const Text("Urdorf"),
            onTap: () {
              context.push("/karte/urdorf");
            },
            trailing: const Icon(
              Icons.navigate_next_sharp,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("Interaktive Karte"),
            onTap: () {
              context.push("/map");
            },
            trailing: const Icon(
              Icons.navigate_next_sharp,
            ),
          ),

        ],
      ),
    );
  }
}
