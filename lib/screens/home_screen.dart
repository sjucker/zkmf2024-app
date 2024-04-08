import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zkmf2024_app/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

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
              const Expanded(
                  child: RotationTransition(
                      turns: AlwaysStoppedAnimation(-12 / 360),
                      child: Text("Musik\nbewegt",
                          style: TextStyle(height: 1, fontSize: 70, fontWeight: FontWeight.bold)))),
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
                    buildCard(context, Icons.announcement_outlined, "News", internalLink: '/news'),
                    buildCard(context, Icons.info_outline, "Informationen", internalLink: '/informationen'),
                    buildCard(context, Icons.music_note_outlined, "Vereine", internalLink: '/vereine'),
                    buildCard(context, Icons.view_timeline_outlined, "Zeitplan", internalLink: '/zeitplan'),
                    buildCard(context, Icons.map_outlined, "Karte", internalLink: '/map'),
                    buildCard(context, Icons.handshake_outlined, "Sponsoring", internalLink: '/sponsoring'),
                    buildCard(context, Icons.celebration_outlined, "Unterhaltung", internalLink: '/unterhaltung'),
                    buildCard(context, Icons.list_alt_outlined, "Festprogramm", internalLink: '/festprogramm'),
                    buildCard(context, Icons.volunteer_activism_outlined, "Helfen",
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

  Card buildCard(BuildContext context, IconData icon, String label, {String? internalLink, String? externalLink}) {
    return Card(
      color: silberTransparent,
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
              color: blau,
              size: 32,
            ),
            Text(
              label,
              style: const TextStyle(color: blau, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
