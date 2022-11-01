import 'package:dantex/com.shockbytes.dante/core/injection/dependency_injector.dart';
import 'package:dantex/com.shockbytes.dante/ui/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await DependencyInjector.initializeCriticalComponents();

  runApp(const DanteXApp());
  /*
  runZonedGuarded(
    () => runApp(const DanteXApp()),
    FirebaseCrashlytics.instance.recordError,
  );
  */
}

class DanteXApp extends StatelessWidget {
  const DanteXApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dante',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: FutureBuilder<bool>(
        future: DependencyInjector.setupDependencyInjection(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Material(child: CircularProgressIndicator.adaptive());
          }
          return MainPage();
        },
      ),
    );
  }
}
