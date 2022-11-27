import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/data/authentication/firebase_authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_authentication_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  UserCredential,
  User,
  UserInfo,
])
void main() {
  const String testEmail = 'test@mail.com';
  const String testPassword = 'password';

  test('Get account returns DanteUser', () async {
    final _fbAuth = MockFirebaseAuth();
    final fbAuthRepo = FirebaseAuthenticationRepository(_fbAuth);
    final User user = MockUser();
    final UserInfo userInfo = MockUserInfo();
    final DanteUser danteUser = DanteUser(
      givenName: 'Dante User',
      displayName: 'Dante User',
      email: 'dante.user@gmail.com',
      photoUrl: 'https://photo-url.com',
      authToken: 'authToken',
      userId: '1',
      source: AuthenticationSource.mail,
    );

    when(userInfo.providerId).thenReturn('password');
    when(user.displayName).thenReturn('Dante User');
    when(user.email).thenReturn('dante.user@gmail.com');
    when(user.photoURL).thenReturn('https://photo-url.com');
    when(user.getIdToken(false)).thenAnswer(
      (_) async => Future<String>.value('authToken'),
    );
    when(user.isAnonymous).thenReturn(false);
    when(user.uid).thenReturn('1');
    when(user.providerData).thenReturn([userInfo]);
    when(_fbAuth.currentUser).thenReturn(user);

    expect(
      await fbAuthRepo.getAccount(),
      danteUser,
    );
    verify(_fbAuth.currentUser).called(1);
  });

  group('Login', () {
    test('Login with Google returns user credential on success', () async {
      final _fbAuth = MockFirebaseAuth();
      final firebaseAuthRepo = FirebaseAuthenticationRepository(_fbAuth);
      final userCred = MockUserCredential();

      when(_fbAuth.signInWithProvider(any)).thenAnswer((_) async => userCred);

      expect(await firebaseAuthRepo.loginWithGoogle(), userCred);
      verify(_fbAuth.signInWithProvider(any)).called(1);
    });

    test('Login anonymously returns User Credential on success', () async {
      final _fbAuth = MockFirebaseAuth();
      final firebaseAuthRepo = FirebaseAuthenticationRepository(_fbAuth);
      final userCred = MockUserCredential();

      when(_fbAuth.signInAnonymously()).thenAnswer((_) async => userCred);

      expect(await firebaseAuthRepo.loginAnonymously(), userCred);
      verify(_fbAuth.signInAnonymously()).called(1);
    });

    test('Login with email returns User Credential on success', () async {
      final _fbAuth = MockFirebaseAuth();
      final firebaseAuthRepo = FirebaseAuthenticationRepository(_fbAuth);
      final userCred = MockUserCredential();

      when(
        _fbAuth.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => userCred);

      expect(
        await firebaseAuthRepo.loginWithEmail(
          email: testEmail,
          password: testPassword,
        ),
        userCred,
      );
      verify(
        _fbAuth.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });
  });

  test('logout returns void on success', () async {
    final _fbAuth = MockFirebaseAuth();
    final firebaseAuthRepo = FirebaseAuthenticationRepository(_fbAuth);

    when(_fbAuth.signOut()).thenAnswer((_) async => Future<void>);

    firebaseAuthRepo.logout();
    verify(_fbAuth.signOut()).called(1);
  });

  test(
    'fetchSignInMethodsForEmail maps sign in methods to AuthenticationSource',
    () async {
      final _fbAuth = MockFirebaseAuth();
      final firebaseAuthRepo = FirebaseAuthenticationRepository(_fbAuth);

      when(_fbAuth.fetchSignInMethodsForEmail(testEmail))
          .thenAnswer((_) async => ['google.com', 'password', 'apple.com']);

      final signInMethods =
          await firebaseAuthRepo.fetchSignInMethodsForEmail(email: testEmail);

      expect(signInMethods, [
        AuthenticationSource.google,
        AuthenticationSource.mail,
        AuthenticationSource.unknown,
      ]);
      verify(_fbAuth.fetchSignInMethodsForEmail(testEmail)).called(1);
    },
  );

  test('Create mail account returns User Credential on success', () async {
    final _fbAuth = MockFirebaseAuth();
    final firebaseAuthRepo = FirebaseAuthenticationRepository(_fbAuth);
    final userCred = MockUserCredential();

    when(
      _fbAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      ),
    ).thenAnswer((_) async => userCred);

    expect(
      await firebaseAuthRepo.createAccountWithMail(
        email: testEmail,
        password: testPassword,
      ),
      userCred,
    );
    verify(
      _fbAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      ),
    ).called(1);
  });
}
