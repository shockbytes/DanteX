import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/data/authentication/firebase_authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication.g.dart';

@riverpod
FirebaseApp firebaseApp(FirebaseAppRef ref) => throw UnimplementedError();

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => FirebaseAuth.instance;

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) =>
    ref.read(firebaseAuthProvider).authStateChanges();

@riverpod
FirebaseDatabase firebaseDatabase(FirebaseDatabaseRef ref) =>
    FirebaseDatabase.instanceFor(
      app: ref.read(firebaseAppProvider),
      databaseURL: 'https://dante-books.europe-west1.firebasedatabase.app/',
    );

@riverpod
AuthenticationRepository authenticationRepository(
  AuthenticationRepositoryRef ref,
) =>
    FirebaseAuthenticationRepository(ref.read(firebaseAuthProvider));

@riverpod
Future<DanteUser?> user(UserRef ref) {
  // Rebuild this provider when there is an auth state change.
  ref.watch(authStateChangesProvider);
  return ref.read(authenticationRepositoryProvider).getAccount();
}
