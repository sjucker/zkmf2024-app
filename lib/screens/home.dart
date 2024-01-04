import 'package:flutter/material.dart';

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
        title: const Text("ZKMF2024 - Festführer"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: Container(
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
                        style: TextStyle(height: 1,
                            fontSize: 70, fontWeight: FontWeight.bold)))),
            Image.asset(
              'assets/hauptsponsoren.png',
              fit: BoxFit.fitWidth,
            ),
          ],
        )),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.music_note),
            icon: Icon(Icons.music_note_outlined),
            label: 'Vereine',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_timeline_outlined),
            selectedIcon: Icon(Icons.view_timeline),
            label: 'Zeitplan',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Informationen',
          ),
        ],
      ),
    );
  }
}
