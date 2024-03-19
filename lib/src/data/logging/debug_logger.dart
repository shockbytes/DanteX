import 'package:dantex/src/data/logging/event.dart';
import 'package:dantex/src/data/logging/logger.dart';

class DebugLogger extends DanteLogger {
  @override
  void trackEvent(DanteEvent event, {Map<String, dynamic>? props}) {
    String message = 'Event: ${event.name}';
    if (props != null && props.isNotEmpty) {
      message += ' - $props';
    }
    d(message);
  }
}
