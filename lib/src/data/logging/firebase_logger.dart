import 'dart:async';

import 'package:dantex/src/data/logging/event.dart';
import 'package:dantex/src/data/logging/logger.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseLogger extends DanteLogger {
  @override
  void trackEvent(DanteTrackingEvent event) {
    // Log the event in the background.
    unawaited(
      FirebaseAnalytics.instance.logEvent(
        name: event.name,
        parameters: event.props,
      ),
    );
  }
}
