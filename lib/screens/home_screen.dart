import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/service/backend_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<bool> _showEmergencyMessage;

  @override
  void initState() {
    super.initState();
    _showEmergencyMessage = hasEmergencyMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ZKMF2024 - Festprogramm"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Einstellungen',
            onPressed: () {
              context.push('/settings');
            },
          )
        ],
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo-home.png',
                fit: BoxFit.fitWidth,
              ),
              Image.asset(
                'assets/hauptsponsoren.png',
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FutureBuilder(
                // TODO rebuild this periodically
                future: _showEmergencyMessage,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.requireData) {
                    return Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextButton(
                          onPressed: () {
                            context.push('/emergency');
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(rot),
                          ),
                          child: const Text(
                            "WICHTIGE NACHRICHT",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ));
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(
                height: 290,
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 90.0,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  children: [
                    buildCard(context, Icons.announcement_outlined, "Aktuelles", silberTransparent, blau,
                        internalLink: '/news'),
                    buildCard(context, Icons.info_outline, "Informationen", silberTransparent, blau,
                        internalLink: '/informationen'),
                    buildCard(context, Icons.list_alt_outlined, "Festprogramm", silberTransparent, blau,
                        internalLink: '/festprogramm'),
                    buildCard(context, Icons.music_note_outlined, "Vereine", silberTransparent, blau,
                        internalLink: '/vereine'),
                    buildCard(context, Icons.view_timeline_outlined, "Spielplan", silberTransparent, blau,
                        internalLink: '/zeitplan'),
                    buildCard(context, Icons.celebration_outlined, "Unterhaltung", silberTransparent, blau,
                        internalLink: '/unterhaltung'),
                    buildCard(context, Icons.map_outlined, "Karte", silberTransparent, blau, internalLink: '/map'),
                    buildCard(context, Icons.handshake_outlined, "Sponsoring", silberTransparent, blau,
                        internalLink: '/sponsoring'),
                    buildCard(context, Icons.volunteer_activism_outlined, "Helfen", silberTransparent, blau,
                        externalLink: 'https://portal.helfereinsatz.ch/zkmf2024'),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Card buildCard(BuildContext context, IconData icon, String label, Color backgroundColor, Color color,
      {String? internalLink, String? externalLink}) {
    return Card(
      color: backgroundColor,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          if (internalLink != null) {
            context.push(internalLink);
          } else if (externalLink != null) {
            launchUrl(Uri.parse(externalLink));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 14),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
