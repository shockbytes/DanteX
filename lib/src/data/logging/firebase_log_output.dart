import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

class FirebaseLogOutput extends LogOutput {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  @override
  void output(OutputEvent event) {
    // We are only interested in log events that contain an exception.
    if (event.origin.error != null) {
      unawaited(
        _crashlytics.recordError(event.origin.error, event.origin.stackTrace),
      );
    }
  }
}
