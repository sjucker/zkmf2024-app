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
                    buildCard(context, Icons.announcement_outlined, "News", silberTransparent, blau,
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
            )
          ],
        ),
      ),
    );
  }
}
