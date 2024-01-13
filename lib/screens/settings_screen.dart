import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _packeInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder(
            future: _packeInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: Text('Version: ${snapshot.requireData.version}+${snapshot.requireData.buildNumber}'));
              } else if (snapshot.error != null) {
                return Center(child: Text(snapshot.error!.toString()));
              } else {
                return const LinearProgressIndicator();
              }
            },
          ),
          TextButton(
              onPressed: () {
                context.push('/settings/changelog');
              },
              child: const Text("Changelog"))
        ],
      ),
    );
  }
}
