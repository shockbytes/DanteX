import 'package:logger/logger.dart';

class ErrorOnlyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.value >= Level.error.value;
  }
}
