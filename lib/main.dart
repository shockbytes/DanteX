import 'dart:async';

import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/ui/login/login_page.dart';
import 'package:dantex/src/ui/main/main_page.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await DependencyInjector.initializeCriticalComponents();

      runApp(const ProviderScope(child: DanteXApp()));
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
    return GetMaterialApp(
      title: 'Dante',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.nunitoTextTheme(),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.nunitoTextTheme(),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _launcher(ref),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data! ? const MainPage() : const LoginPage();
          } else {
            return const Material(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }

  Future<bool> _launcher(WidgetRef ref) async {
    await DependencyInjector.setupDependencyInjection();

    final bloc = ref.read(authBlocProvider);
    return bloc.isLoggedIn();
  }
}
