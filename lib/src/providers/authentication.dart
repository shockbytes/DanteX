import 'package:dantex/src/data/authentication/firebase_authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication.g.dart';

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => FirebaseAuth.instance;

@riverpod
FirebaseDatabase firebaseDatabase(FirebaseDatabaseRef ref) =>
    throw UnimplementedError();

@riverpod
FirebaseAuthenticationRepository firebaseAuthenticationRepository(
  FirebaseAuthenticationRepositoryRef ref,
) =>
    FirebaseAuthenticationRepository(ref.read(firebaseAuthProvider));
