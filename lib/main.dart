import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zkmf2024_app/constants.dart';
import 'package:zkmf2024_app/firebase_options.dart';
import 'package:zkmf2024_app/screens/changelog_screen.dart';
import 'package:zkmf2024_app/screens/dynamic_page_screen.dart';
import 'package:zkmf2024_app/screens/emergency_screen.dart';
import 'package:zkmf2024_app/screens/festprogramm_screen.dart';
import 'package:zkmf2024_app/screens/general_error_screen.dart';
import 'package:zkmf2024_app/screens/home_screen.dart';
import 'package:zkmf2024_app/screens/impressum_screen.dart';
import 'package:zkmf2024_app/screens/informationen_screen.dart';
import 'package:zkmf2024_app/screens/jury_screen.dart';
import 'package:zkmf2024_app/screens/karte_schlieren_screen.dart';
import 'package:zkmf2024_app/screens/karte_screen.dart';
import 'package:zkmf2024_app/screens/karte_urdorf_screen.dart';
import 'package:zkmf2024_app/screens/location_screen.dart';
import 'package:zkmf2024_app/screens/locations_screen.dart';
import 'package:zkmf2024_app/screens/map_screen.dart';
import 'package:zkmf2024_app/screens/news_screen.dart';
import 'package:zkmf2024_app/screens/ranking_screen.dart';
import 'package:zkmf2024_app/screens/rankings_screen.dart';
import 'package:zkmf2024_app/screens/settings_screen.dart';
import 'package:zkmf2024_app/screens/sponsoring_screen.dart';
import 'package:zkmf2024_app/screens/timetable_screen.dart';
import 'package:zkmf2024_app/screens/unterhaltung_detail_screen.dart';
import 'package:zkmf2024_app/screens/unterhaltung_screen.dart';
import 'package:zkmf2024_app/screens/verein_screen.dart';
import 'package:zkmf2024_app/screens/vereine_screen.dart';
import 'package:zkmf2024_app/service/firebase_messaging.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  setupMessaging();

  await requestPermissionAndSubscribe(false);
}

Future<void> setupMessaging() async {
  var initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    navigate(initialMessage);
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    displayNotificationMessage(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    navigate(message);
  });
}

void displayNotificationMessage(RemoteMessage message) {
  if (navigatorKey.currentContext == null) {
    return;
  }
  showDialog(
    context: navigatorKey.currentContext!,
    barrierDismissible: false,
    builder: (context) {
      return SimpleDialog(
        title: Text(message.notification?.title ?? ''),
        backgroundColor: blau,
        contentPadding: const EdgeInsets.all(10),
        children: [
          ListTile(
            title: Text(message.notification?.body ?? ""),
          ),
          FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (message.data.containsKey("route")) {
                  context.push(message.data["route"]);
                }
              },
              child: const Text("weiter"))
        ],
      );
    },
  );
}

void navigate(RemoteMessage message) {
  if (message.data.containsKey("route")) {
    navigatorKey.currentContext?.go(message.data["route"]);
  }
}

void main() async {
  await GetStorage.init();
  await initFirebase();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

final _router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/informationen',
      builder: (context, state) => const InformationenScreen(),
    ),
    GoRoute(path: '/wettspiellokale', builder: (context, state) => const LocationsScreen(), routes: [
      GoRoute(
          path: ':identifier',
          builder: (context, state) => LocationScreen(identifier: state.pathParameters['identifier']!))
    ]),
    GoRoute(path: '/vereine', builder: (context, state) => const VereineScreen(), routes: [
      GoRoute(
          path: ':identifier',
          builder: (context, state) => VereinScreen(identifier: state.pathParameters['identifier']!))
    ]),
    GoRoute(
      path: '/zeitplan',
      builder: (context, state) => const TimetableScreen(),
    ),
    GoRoute(
      path: '/news',
      builder: (context, state) => const NewsScreen(),
    ),
    GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [GoRoute(path: 'changelog', builder: (context, state) => const ChangelogScreen())]),
    GoRoute(path: '/karte', builder: (context, state) => const KarteScreen(), routes: [
      GoRoute(
        path: 'schlieren',
        builder: (context, state) => const KarteSchlierenScreen(),
      ),
      GoRoute(
        path: 'urdorf',
        builder: (context, state) => const KarteUrdorfScreen(),
      ),
    ]),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/sponsoring',
      builder: (context, state) => const SponsoringScreen(),
    ),
    GoRoute(path: '/unterhaltung', builder: (context, state) => const UnterhaltungScreen(), routes: [
      GoRoute(
          path: ':identifier',
          builder: (context, state) => UnterhaltungDetailScreen(identifier: state.pathParameters['identifier']!))
    ]),
    GoRoute(path: '/festprogramm', builder: (context, state) => const FestprogrammScreen()),
    GoRoute(path: '/jurymitglieder', builder: (context, state) => const JuryScreen()),
    GoRoute(path: '/impressum', builder: (context, state) => const ImpressumScreen()),
    GoRoute(
        path: '/page/:id', builder: (context, state) => DynamicPageScreen(id: int.parse(state.pathParameters['id']!))),
    GoRoute(path: '/emergency', builder: (context, state) => const EmergencyScreen()),
    GoRoute(path: '/ranglisten', builder: (context, state) => const RankingsScreen(), routes: [
      GoRoute(
          path: ':id',
          builder: (context, state) => RankingScreen(id: int.parse(state.pathParameters['id']!)))
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
          ),
          expansionTileTheme: const ExpansionTileThemeData(
              textColor: Colors.white,
              collapsedTextColor: Colors.white,
              iconColor: Colors.white,
              collapsedIconColor: Colors.white)),
    );
  }
}
