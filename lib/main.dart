import 'dart:async';

import 'package:dantex/firebase_options.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/add/scan_book_page.dart';
import 'package:dantex/src/ui/boot_page.dart';
import 'package:dantex/src/ui/login/login_page.dart';
import 'package:dantex/src/ui/main/main_page.dart';
import 'package:dantex/src/ui/profile/profile_page.dart';
import 'package:dantex/src/ui/settings/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Don't record errors with Crashlytics on Web
      if (!kIsWeb) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      }

      runApp(
        ProviderScope(
          overrides: [
            firebaseAppProvider.overrideWithValue(firebaseApp),
          ],
          child: const DanteXApp(),
        ),
      );
    },
    (error, stackTrace) {
      // If not web, record the errors
      if (!kIsWeb) {
        FirebaseCrashlytics.instance
            .recordError(error, stackTrace, fatal: true);
      }
    },
  );
}

class DanteXApp extends ConsumerWidget {
  const DanteXApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Dante',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorSchemeSeed: Colors.white,
        brightness: Brightness.light,
        textTheme: GoogleFonts.nunitoTextTheme(),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.white,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.nunitoTextTheme(),
        useMaterial3: true,
      ),
    );
  }

}

enum DanteRoute {
  boot(
    url: '/boot',
    navigationUrl: '/boot',
  ),
  login(
    url: '/login',
    navigationUrl: '/login',
  ),
  dashboard(
    url: '/',
    navigationUrl: '/',
  ),
  scanBook(
    url: 'scan',
    navigationUrl: '/scan',
  ),
  settings(
    url: 'settings',
    navigationUrl: '/settings',
  ),
  profile(
    url: 'profile',
    navigationUrl: '/profile',
  );

  /// Url used for registering the route in the [_router] field.
  final String url;
  /// Used for navigating to another screen, when calling context.go()
  final String navigationUrl;

  const DanteRoute({
    required this.url,
    required this.navigationUrl,
  });
}

final GoRouter _router = GoRouter(
  initialLocation: DanteRoute.boot.url,
  routes: [
    GoRoute(
      path: DanteRoute.boot.url,
      builder: (BuildContext context, GoRouterState state) => const BootPage(),
    ),
    GoRoute(
      path: DanteRoute.login.url,
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
    GoRoute(
      path: DanteRoute.dashboard.url,
      builder: (BuildContext context, GoRouterState state) => const MainPage(),
      routes: [
        GoRoute(
          path: DanteRoute.settings.url,
          builder: (BuildContext context, GoRouterState state) => const SettingsPage(),
        ),
        GoRoute(
          path: DanteRoute.profile.url,
          builder: (BuildContext context, GoRouterState state) => const ProfilePage(),
        ),
        GoRoute(
          path: DanteRoute.scanBook.url,
          builder: (BuildContext context, GoRouterState state) => const ScanBookPage(),
        ),
      ],
    ),
  ],
);
