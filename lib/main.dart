import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/screens/home_screen.dart';
import 'package:zkmf2024_app/screens/location_screen.dart';
import 'package:zkmf2024_app/screens/locations_screen.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
        path: '/wettspiellokale',
        builder: (context, state) => const LocationsScreen(),
        routes: [
          GoRoute(
              path: ':identifier',
              builder: (context, state) {
                return LocationScreen(
                    identifier: state.pathParameters['identifier']!);
              })
        ])
  ],
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'ZKMF2024',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Colors.white,
            onPrimary: Colors.black,
            secondary: gelb,
            onSecondary: Colors.black,
            background: blau,
            onBackground: Colors.white,
            error: rot,
            onError: Colors.black,
            surface: silber,
            onSurface: Colors.black,
          ),
          textTheme: GoogleFonts.poppinsTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: rot),
          filledButtonTheme: FilledButtonThemeData(
            style: TextButton.styleFrom(
                backgroundColor: rot, foregroundColor: Colors.white),
          )),
    );
  }
}
