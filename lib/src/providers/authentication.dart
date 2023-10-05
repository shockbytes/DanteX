import 'package:dantex/firebase_options.dart';
import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/data/authentication/firebase_authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication.g.dart';

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => FirebaseAuth.instance;

@riverpod
Future<FirebaseDatabase> firebaseDatabase(FirebaseDatabaseRef ref) async =>
    FirebaseDatabase.instanceFor(
      app: await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      databaseURL: 'https://dante-books.europe-west1.firebasedatabase.app/',
    );

@riverpod
FirebaseAuthenticationRepository firebaseAuthenticationRepository(
  FirebaseAuthenticationRepositoryRef ref,
) =>
    FirebaseAuthenticationRepository(ref.read(firebaseAuthProvider));

@riverpod
AuthBloc authBloc(AuthBlocRef ref) => AuthBloc(
      ref.read(firebaseAuthenticationRepositoryProvider),
    );
