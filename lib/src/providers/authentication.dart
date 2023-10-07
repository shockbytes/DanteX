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
FirebaseDatabase firebaseDatabase(FirebaseDatabaseRef ref) =>
    FirebaseDatabase.instanceFor(
      app: ref.read(firebaseAppProvider),
      databaseURL: 'https://dante-books.europe-west1.firebasedatabase.app/',
    );

@riverpod
class AuthenticationRepository extends _$AuthenticationRepository {
  @override
  FirebaseAuthenticationRepository build() {
    return FirebaseAuthenticationRepository(ref.read(firebaseAuthProvider));
  }

  Future<bool> isLoggedIn() async {
    return (await state.getAccount()) != null;
  }

  Future<void> logout() async {
    return state.logout();
  }
}
