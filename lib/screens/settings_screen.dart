import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
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
  late Future<PermissionStatus> _locationSettings;

  @override
  void initState() {
    super.initState();

    _emergency = _box.read("topic-emergency") ?? false;
    _general = _box.read("topic-general") ?? false;
    _notificationSettings = Permission.notification.status;
    _locationSettings = Permission.location.status;
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Benachrichtigungen",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          FutureBuilder(
              future: _notificationSettings,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.requireData.isGranted) {
                    return Column(
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
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: TextButton.icon(
                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.white)),
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
                                    content: Text(
                                        'Benachrichtigungen konnten nicht aktiviert werden, bitte Änderungen in Systemeinstellung vornehmen'),
                                    backgroundColor: rot,
                                  ));
                                }
                              },
                              icon: const Icon(
                                Icons.notification_add,
                                color: blau,
                              ),
                              label: const Text(
                                "aktivieren",
                                style: TextStyle(color: blau),
                              )),
                        ),
                      ],
                    );
                  }
                } else {
                  return const LinearProgressIndicator();
                }
              }),
          const Divider(
            indent: 20,
            endIndent: 20,
            color: gruen,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Ortungsdienste",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          FutureBuilder(
            future: _locationSettings,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.requireData.isPermanentlyDenied || snapshot.requireData.isDenied) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: TextButton.icon(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.white)),
                            onPressed: () async {
                              var status = await Permission.location.request();
                              if (status.isGranted) {
                                // reload page
                                setState(() {
                                  _locationSettings = Permission.location.status;
                                });
                              } else {
                                if (!context.mounted) {
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text(
                                      'Ortungsdienste konnten nicht aktiviert werden, bitte Änderungen in Systemeinstellung vornehmen'),
                                  backgroundColor: rot,
                                ));
                              }
                            },
                            icon: const Icon(
                              Icons.location_disabled_outlined,
                              color: blau,
                            ),
                            label: const Text(
                              "aktivieren",
                              style: TextStyle(color: blau),
                            )),
                      ),
                    ],
                  );
                } else {
                  return const ListTile(
                    leading: Icon(Icons.my_location_outlined),
                    title: Text("aktiviert"),
                  );
                }
              } else {
                return const LinearProgressIndicator();
              }
            },
          ),
          Expanded(child: Container()),
          FutureBuilder(
            future: _packeInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: GestureDetector(
                        onDoubleTap: () {
                          FirebaseMessaging.instance.getToken().then((value) => {
                                if (value != null) {Clipboard.setData(ClipboardData(text: value))}
                              });
                        },
                        child: Text('Version: ${snapshot.requireData.version}+${snapshot.requireData.buildNumber}')));
              } else if (snapshot.error != null) {
                return Center(child: Text(snapshot.error!.toString()));
              } else {
                return const LinearProgressIndicator();
              }
            },
          ),
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
