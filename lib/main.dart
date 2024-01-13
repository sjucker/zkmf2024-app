import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/screens/changelog_screen.dart';
import 'package:zkmf2024_app/screens/general_error_screen.dart';
import 'package:zkmf2024_app/screens/home_screen.dart';
import 'package:zkmf2024_app/screens/location_screen.dart';
import 'package:zkmf2024_app/screens/locations_screen.dart';
import 'package:zkmf2024_app/screens/news_screen.dart';
import 'package:zkmf2024_app/screens/settings_screen.dart';
import 'package:zkmf2024_app/screens/timetable_screen.dart';
import 'package:zkmf2024_app/screens/verein_screen.dart';
import 'package:zkmf2024_app/screens/vereine_screen.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/wettspiellokale', builder: (context, state) => const LocationsScreen(), routes: [
      GoRoute(
          path: ':identifier',
          builder: (context, state) {
            return LocationScreen(identifier: state.pathParameters['identifier']!);
          })
    ]),
    GoRoute(path: '/vereine', builder: (context, state) => const VereineScreen(), routes: [
      GoRoute(
          path: ':identifier',
          builder: (context, state) {
            return VereinScreen(identifier: state.pathParameters['identifier']!);
          })
    ]),
    GoRoute(
      path: '/zeitplan',
      builder: (context, state) => const TimetableScreen(),
    ),
    GoRoute(
      path: '/news',
      builder: (context, state) => const NewsScreen(),
    ),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen(), routes: [
      GoRoute(
          path: 'changelog',
          builder: (context, state) {
            return const ChangelogScreen();
          })
    ])
  ],
  errorBuilder: (context, state) => const GeneralErrorScreen(),
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
      debugShowCheckedModeBanner: false,
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
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: rot),
          filledButtonTheme: FilledButtonThemeData(
            style: TextButton.styleFrom(backgroundColor: rot, foregroundColor: Colors.white),
          ),
          listTileTheme: const ListTileThemeData(
            textColor: Colors.white,
            iconColor: gruen,
          )),
    );
  }
}
