import 'package:dantex/logger/dante_logger.dart';
import 'package:dantex/logger/debug_logger.dart';
import 'package:dantex/logger/firebase_logger.dart';
import 'package:dantex/models/realm_book.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realm/realm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'service.g.dart';

@riverpod
DanteLogger logger(Ref ref) {
  // If we are in dev mode, return debug tracker.
  if (kDebugMode) {
    return DebugLogger();
  }
  return FirebaseLogger();
}

@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('sharedPreferences has not been initialized');
}

@riverpod
Realm realm(Ref ref) {
  return Realm(
    Configuration.local(
      [
        RealmBook.schema,
        RealmBookLabel.schema,
        RealmPageRecord.schema,
      ],
      // 9 is the current schema version of the old app.
      schemaVersion: 9,
    ),
  );
}
