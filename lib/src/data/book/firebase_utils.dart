import 'package:firebase_database/firebase_database.dart';

extension DataSnapshotExtension on DataSnapshot {
  Map<String, dynamic>? toMap() {
    return (value != null) ? (value as Map<dynamic, dynamic>).cast() : null;
  }
}
