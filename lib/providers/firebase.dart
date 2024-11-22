import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase.g.dart';

@riverpod
FirebaseApp firebaseApp(Ref ref) => throw UnimplementedError();

@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@riverpod
FirebaseDatabase? firebaseDatabase(Ref ref) {
  return FirebaseDatabase.instanceFor(
    app: ref.watch(firebaseAppProvider),
    databaseURL: 'https://dante-books.europe-west1.firebasedatabase.app/',
  );
}
