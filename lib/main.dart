import 'dart:async';

import 'package:dantex/firebase_options.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/providers/router.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/providers/settings.dart';
import 'package:dantex/theme/theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await EasyLocalization.ensureInitialized();
      await Firebase.initializeApp();
      final sharedPreferences = await SharedPreferences.getInstance();

      // Don't record errors with Crashlytics on Web
      if (!kIsWeb) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      }

      runApp(
        DevicePreview(
          builder: (context) => ProviderScope(
            overrides: [
              firebaseAppProvider.overrideWithValue(firebaseApp),
              sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            ],
            child: EasyLocalization(
              supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
              path: 'assets/translations',
              fallbackLocale: const Locale('en', 'US'),
              child: const DanteXApp(),
            ),
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

class DanteXApp extends ConsumerWidget {
  const DanteXApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeSettingProvider);

    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      title: 'Dante',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: CustomTheme.lightThemeData(),
      darkTheme: CustomTheme.darkThemeData(),
      themeMode: themeMode,
    );
  }
}
