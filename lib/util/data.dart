import 'package:firebase_database/firebase_database.dart';

extension DataSnapshotX on DataSnapshot {
  Map<String, dynamic>? toMap() {
    return (value != null) ? (value! as Map<dynamic, dynamic>).cast() : null;
  }
}
