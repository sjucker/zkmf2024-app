import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/dto/verein_overview.dart';
import 'package:zkmf2024_app/service/backend_service.dart';
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
  late Future<List<VereinOverviewDTO>> _vereine;

  late String? _selectedVerein;

  @override
  void initState() {
    super.initState();

    _emergency = _box.read("topic-emergency") ?? false;
    _general = _box.read("topic-general") ?? false;
    _notificationSettings = Permission.notification.status;
    _locationSettings = Permission.location.status;
    _vereine = fetchVereine();
    _selectedVerein = _box.read(selectedVereinKey);
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
              child: Row(
                children: [
                  Text(
                    "Benachrichtigungen",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Tooltip(
                      message: '''
Falls Benachrichtigungen nicht in der App aktiviert werden können, bitte folgende Schritte vornehmen:
- iOS: Einstellungen -> Mitteilungen -> Mitteilungsstil -> ZKMF2024 App -> Mitteilungen erlauben
- Android: Einstellungen -> Apps -> ZKMF2024 App -> Benachrichtigungen: Benachrichtigungen aktivieren
''',
                      triggerMode: TooltipTriggerMode.tap,
                      showDuration: Duration(seconds: 20),
                      margin: EdgeInsets.all(10),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: gruen,
                      ),
                    ),
                  )
                ],
              )),
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
                                      'Benachrichtigungen konnten nicht aktiviert werden, bitte Änderungen in den Systemeinstellungen vornehmen.',
                                      style: TextStyle(color: Colors.white),
                                    ),
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
              child: Row(
                children: [
                  Text(
                    "Ortungsdienste",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Tooltip(
                      message: '''
Falls Ortungsdienste nicht in der App aktiviert werden können, bitte folgende Schritte vornehmen:
- iOS: Einstellungen -> Datenschutz & Sicherheit -> Ortungsdienste -> aktivieren (ZKMF2024 App: "beim Verwenden der App" oder "immer")
- Android: Einstellungen -> Apps -> ZKMF2024 App -> Berechtigungen -> Standort:  Benachrichtigungen: "Zugriff nur während der Nutzung der App zulassen" oder "immer zulassen"
''',
                      triggerMode: TooltipTriggerMode.tap,
                      showDuration: Duration(seconds: 20),
                      margin: EdgeInsets.all(10),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: gruen,
                      ),
                    ),
                  )
                ],
              )),
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
                                    'Ortungsdienste konnten nicht aktiviert werden, bitte Änderungen in den Systemeinstellungen vornehmen',
                                    style: TextStyle(color: Colors.white),
                                  ),
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
          const Divider(
            indent: 20,
            endIndent: 20,
            color: gruen,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  "Vereinszugehörigkeit",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Tooltip(
                    message:
                        'Nimmst du als Musikant/in am ZKMF2024 teil? Dann trage hier deinen Verein ein, um detaillierte Informationen und Benachrichtigungen zu deinem Programm zu erhalten.\nStelle sicher, dass du Benachrichtigungen aktiviert hast, damit wir dich über wichtige Änderungen informieren können.',
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: Duration(seconds: 10),
                    margin: EdgeInsets.all(10),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: gruen,
                    ),
                  ),
                )
              ],
            ),
          ),
          FutureBuilder(
            future: _vereine,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var vereine = snapshot.requireData;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButton<String>(
                    value: _selectedVerein,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('---'),
                      ),
                      ...vereine.map((e) => DropdownMenuItem<String>(
                          value: e.identifier,
                          child: Text(
                            e.name,
                          )))
                    ],
                    onChanged: (value) async {
                      if (value != null) {
                        // make sure user has granted permission
                        await requestPermissionAndSubscribe(true);
                      }
                      setState(() {
                        if (value != null) {
                          _box.write(selectedVereinKey, value);
                          member(value);
                        } else {
                          _box.remove(selectedVereinKey);
                        }
                        if (_selectedVerein != null) {
                          // unsubscribe from previous selection
                          unmember(_selectedVerein!);
                        }
                        _selectedVerein = value;
                      });
                    },
                    iconEnabledColor: gruen,
                  ),
                );
              } else {
                return Container();
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
