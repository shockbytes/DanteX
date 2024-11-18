import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

@riverpod
DatabaseReference? bookDatabase(Ref ref) {
  final database = ref.watch(firebaseDatabaseProvider);

  if (database == null) {
    return null;
  }

  // Only watch authStateChanges here so that the database reference is only
  // recreated when the user signs in or out.
  final userId = ref.watch(authStateChangesProvider).value?.uid;
  if (userId == null) {
    return null;
  }

  return database.ref('users/$userId/books');
}

@riverpod
FirebaseDatabase? firebaseDatabase(Ref ref) {
  return FirebaseDatabase.instanceFor(
    app: ref.watch(firebaseAppProvider),
    databaseURL: 'https://dante-books.europe-west1.firebasedatabase.app/',
  );
}
