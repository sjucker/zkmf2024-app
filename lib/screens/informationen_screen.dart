import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InformationenScreen extends StatelessWidget {
  const InformationenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informationen'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.map_outlined),
            trailing: const Icon(
              Icons.navigate_next_sharp,
            ),
            onTap: () {
              context.push('/karte');
            },
            title: const Text("Karte Festareal"),
          ),
          ListTile(
            leading: const Icon(Icons.house_outlined),
            trailing: const Icon(
              Icons.navigate_next_sharp,
            ),
            onTap: () {
              context.push('/wettspiellokale');
            },
            title: const Text("Wettspiellokale"),
          ),
        ],
      ),
    );
  }
}
