import 'package:flutter/material.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/screens/locations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
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
                        style: TextStyle(
                            height: 1,
                            fontSize: 70,
                            fontWeight: FontWeight.bold)))),
            Image.asset(
              'assets/hauptsponsoren.png',
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
      HomeScreen(),
      LocationsScreen(),
      HomeScreen()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("ZKMF2024 - Festführer"),
      ),
      body: _screens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.announcement),
            icon: Icon(Icons.announcement_outlined),
            label: 'News',
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
