import 'package:dantex/src/data/logging/error_only_filter.dart';
import 'package:dantex/src/data/logging/event.dart';
import 'package:dantex/src/data/logging/firebase_log_output.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

abstract class DanteLogger extends Logger {
  DanteLogger()
      : super(
          filter: kDebugMode ? DevelopmentFilter() : ErrorOnlyFilter(),
          printer: PrettyPrinter(
            methodCount: 0,
            printTime: true,
          ),
          // Use Firebase logging only for production
          output: kDebugMode ? ConsoleOutput() : FirebaseLogOutput(),
        );

  void trackEvent(DanteTrackingEvent event);
}
