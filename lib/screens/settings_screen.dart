import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/service/firebase_messaging.dart';
import 'package:zkmf2024_app/widgets/to_home_action.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _packeInfo = PackageInfo.fromPlatform();
  final _box = GetStorage();

  late bool _emergency;
  late bool _general;

  late Future<PermissionStatus> _notificationSettings;

  @override
  void initState() {
    super.initState();

    _emergency = _box.read("topic-emergency") ?? false;
    _general = _box.read("topic-general") ?? false;
    _notificationSettings = Permission.notification.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
        actions: homeAction(context),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder(
            future: _notificationSettings,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.requireData.isGranted) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Benachrichtigungen",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Benachrichtigungen deaktiviert",
                    ),
                  );
                }
              } else {
                return const LinearProgressIndicator();
              }
            },
          ),
          FutureBuilder(
              future: _notificationSettings,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.requireData.isGranted) {
                    return Expanded(
                        child: ListView(
                      children: [
                        SwitchListTile.adaptive(
                            title: const Text("Notfall"), value: _emergency, onChanged: null // disabled
                            ),
                        SwitchListTile.adaptive(
                          title: const Text("Allgemein"),
                          value: _general,
                          onChanged: (value) {
                            if (value) {
                              subscribeTo(generalTopic);
                            } else {
                              unsubscribeFrom(generalTopic);
                            }
                            setState(() {
                              _general = value;
                            });
                          },
                        )
                      ],
                    ));
                  } else {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextButton.icon(
                                onPressed: () async {
                                  var authorized = await requestPermissionAndSubscribe(true);
                                  if (authorized) {
                                    // reload page
                                    setState(() {
                                      _emergency = true;
                                      _general = true;
                                      _notificationSettings = Permission.notification.status;
                                    });
                                  } else {
                                    if (!context.mounted) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Benachrichtigungen konnten nicht aktiviert werden'),
                                    ));
                                  }
                                },
                                icon: const Icon(Icons.notification_add),
                                label: const Text("aktivieren")),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return const LinearProgressIndicator();
                }
              }),
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
              child: const Text("Changelog")),
          const Divider(
            indent: 20,
            endIndent: 20,
            color: gruen,
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text("built by"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 0, 100, 20),
                child: InkWell(
                  onTap: () {
                    launchUrl(Uri.parse('https://www.mptechnology.ch'));
                  },
                  child: Image.asset(
                    'assets/logo-mp.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
