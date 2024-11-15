import 'package:dantex/data/logger/dante_logger.dart';
import 'package:dantex/data/logger/debug_logger.dart';
import 'package:dantex/data/logger/firebase_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger.g.dart';

@riverpod
DanteLogger logger(Ref ref) {
  // If we are in dev mode, return debug tracker.
  if (kDebugMode) {
    return DebugLogger();
  }
  return FirebaseLogger();
}
