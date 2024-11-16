import 'dart:async';

import 'package:dantex/logger/dante_logger.dart';
import 'package:dantex/logger/event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

class FirebaseLogger extends DanteLogger {
  FirebaseLogger()
      : super(
          filter: _ErrorOnlyFilter(),
          output: _FirebaseLogOutput(),
        );

  @override
  void trackEvent(DanteEvent event, {Map<String, Object>? data}) {
    // Log the event in the background.
    unawaited(
      FirebaseAnalytics.instance.logEvent(
        name: event.name,
        parameters: data,
      ),
    );
  }
}

class _FirebaseLogOutput extends LogOutput {
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

class _ErrorOnlyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.value >= Level.error.value;
  }
}
