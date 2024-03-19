import 'package:dantex/src/data/logging/event.dart';
import 'package:dantex/src/data/logging/logger.dart';

class DebugLogger extends DanteLogger {
  @override
  void trackEvent(DanteTrackingEvent event) {
    String message = 'Event: ${event.name}';
    if (event.props.isNotEmpty) {
      message += ' - ${event.props}';
    }
    d(message);
  }
}
