import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/data/authentication/firebase_authentication_repository.dart';
import 'package:dantex/src/data/authentication/on_user_authenticated_plugin.dart';
import 'package:dantex/src/data/authentication/plugin/realm_migration_on_user_authenticated_plugin.dart';
import 'package:dantex/src/providers/migration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' hide User;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication.g.dart';

@riverpod
FirebaseApp firebaseApp(FirebaseAppRef ref) => throw UnimplementedError();

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => FirebaseAuth.instance;

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) =>
    ref.watch(firebaseAuthProvider).authStateChanges();

@riverpod
FirebaseDatabase firebaseDatabase(FirebaseDatabaseRef ref) =>
    FirebaseDatabase.instanceFor(
      app: ref.watch(firebaseAppProvider),
      databaseURL: 'https://dante-books.europe-west1.firebasedatabase.app/',
    );

@Riverpod(keepAlive: true)
AuthenticationRepository authenticationRepository(
  AuthenticationRepositoryRef ref,
) =>
    FirebaseAuthenticationRepository(
      ref.watch(firebaseAuthProvider),
      _provideOnUserAuthenticatedPlugins(ref),
    );

List<OnUserAuthenticatedPlugin> _provideOnUserAuthenticatedPlugins(
  AuthenticationRepositoryRef ref,
) =>
    [
      RealmMigrationOnUserAuthenticatedPlugin(
        ref.read(migrationRunnerProvider),
      ),
    ];

@riverpod
Future<DanteUser?> user(UserRef ref) {
  // Rebuild this provider when there is an auth state change.
  ref.watch(authStateChangesProvider);
  return ref.watch(authenticationRepositoryProvider).getAccount();
}

@riverpod
GoogleSignIn googleSignIn(
  GoogleSignInRef ref,
) =>
    GoogleSignIn(
      clientId:
          '150599422814-moto7djse1tf7vtso7slemniki76ohg6.apps.googleusercontent.com',
      scopes: [
        DriveApi.driveFileScope,
      ],
    );
