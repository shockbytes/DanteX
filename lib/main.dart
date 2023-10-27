import 'dart:async';

import 'package:dantex/firebase_options.dart';
import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await EasyLocalization.ensureInitialized();

      final List<Override> overrides = await _initializeBlockingDependencies();

      // Don't record errors with Crashlytics on Web
      if (!kIsWeb) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      }

      runApp(
        ProviderScope(
          overrides: overrides,
          child: EasyLocalization(
            supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
            path: 'assets/translations',
            fallbackLocale: const Locale('en', 'US'),
            child: const DanteXApp(),
          ),
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

Future<List<Override>> _initializeBlockingDependencies() async {
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

  return [
    firebaseAppProvider.overrideWithValue(firebaseApp),
    sharedPreferencesProvider.overrideWithValue(sharedPrefs),
  ];
}

class DanteXApp extends ConsumerWidget {
  const DanteXApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<ThemeMode>(
      stream: ref.watch(settingsRepositoryProvider).observeThemeMode(),
      builder: (context, snapshot) {
        final ThemeMode themeMode = snapshot.data ?? ThemeMode.system;
        return MaterialApp.router(
          routerConfig: ref.watch(goRouterProvider),
          title: 'Dante',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: themeMode,
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
      },
    );
  }
}
