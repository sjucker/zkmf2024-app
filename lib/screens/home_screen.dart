import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                    crossAxisCount: 2,
                    mainAxisExtent: 90.0,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  children: [
                    buildCard(context, Icons.announcement_outlined, "News", '/news'),
                    buildCard(context, Icons.info_outline, "Informationen", '/informationen'),
                    buildCard(context, Icons.music_note_outlined, "Vereine", '/vereine'),
                    buildCard(context, Icons.view_timeline_outlined, "Zeitplan", '/zeitplan'),
                    buildCard(context, Icons.map_outlined, "Karte", '/map'),
                    buildCard(context, Icons.handshake_outlined, "Sponsoring", '/sponsoring'),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Card buildCard(BuildContext context, IconData icon, String label, String location) {
    return Card(
      color: silberTransparent,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          context.push(location);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: blau,
              size: 40,
            ),
            Text(
              label,
              style: const TextStyle(color: blau, fontWeight: FontWeight.bold, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
