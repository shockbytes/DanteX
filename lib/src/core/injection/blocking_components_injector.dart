import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../../firebase_options.dart';

class BlockingComponentsInjector {
  BlockingComponentsInjector._();

  static Future setup() async {
    await _setupFirebase();
  }

  static Future _setupFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Don't record errors with Crashlytics on Web
    if (!kIsWeb) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
  }
}
