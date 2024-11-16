import 'package:dantex/logger/event.dart';
import 'package:logger/logger.dart';

abstract class DanteLogger extends Logger {
  DanteLogger({
    super.filter,
    super.output,
  }) : super(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 5,
          ),
        );

  void trackEvent(DanteEvent event, {Map<String, Object>? data});
}
