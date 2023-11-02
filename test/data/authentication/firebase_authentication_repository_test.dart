// ignore_for_file: discarded_futures

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
    final fbAuth = MockFirebaseAuth();
    final fbAuthRepo = FirebaseAuthenticationRepository(fbAuth);
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
    when(user.getIdToken()).thenAnswer(
      (_) async => Future<String>.value('authToken'),
    );
    when(user.isAnonymous).thenReturn(false);
    when(user.uid).thenReturn('1');
    when(user.providerData).thenReturn([userInfo]);
    when(fbAuth.currentUser).thenReturn(user);

    expect(
      await fbAuthRepo.getAccount(),
      danteUser,
    );
    verify(fbAuth.currentUser).called(1);
  });

  group('Login', () {
    test('Login with Google returns user credential on success', () async {
      final fbAuth = MockFirebaseAuth();
      final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);
      final userCred = MockUserCredential();

      when(fbAuth.signInWithProvider(any)).thenAnswer((_) async => userCred);

      expect(await firebaseAuthRepo.loginWithGoogle(), userCred);
      verify(fbAuth.signInWithProvider(any)).called(1);
    });

    test('Login anonymously returns User Credential on success', () async {
      final fbAuth = MockFirebaseAuth();
      final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);
      final userCred = MockUserCredential();

      when(fbAuth.signInAnonymously()).thenAnswer((_) async => userCred);

      expect(await firebaseAuthRepo.loginAnonymously(), userCred);
      verify(fbAuth.signInAnonymously()).called(1);
    });

    test('Login with email returns User Credential on success', () async {
      final fbAuth = MockFirebaseAuth();
      final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);
      final userCred = MockUserCredential();

      when(
        fbAuth.signInWithEmailAndPassword(
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
        fbAuth.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });
  });

  test('logout returns void on success', () async {
    final fbAuth = MockFirebaseAuth();
    final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);

    when(fbAuth.signOut()).thenAnswer((_) async => Future<void>);

    await firebaseAuthRepo.logout();
    verify(fbAuth.signOut()).called(1);
  });

  test(
    'fetchSignInMethodsForEmail maps sign in methods to AuthenticationSource',
    () async {
      final fbAuth = MockFirebaseAuth();
      final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);

      when(fbAuth.fetchSignInMethodsForEmail(testEmail))
          .thenAnswer((_) async => ['google.com', 'password', 'apple.com']);

      final signInMethods =
          await firebaseAuthRepo.fetchSignInMethodsForEmail(email: testEmail);

      expect(signInMethods, [
        AuthenticationSource.google,
        AuthenticationSource.mail,
        AuthenticationSource.unknown,
      ]);
      verify(fbAuth.fetchSignInMethodsForEmail(testEmail)).called(1);
    },
  );

  test('Create mail account returns User Credential on success', () async {
    final fbAuth = MockFirebaseAuth();
    final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);
    final userCred = MockUserCredential();

    when(
      fbAuth.createUserWithEmailAndPassword(
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
      fbAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      ),
    ).called(1);
  });

  test('Upgrade anonymous account returns User Credential on success',
      () async {
    final fbAuth = MockFirebaseAuth();
    final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);
    final user = MockUser();
    final userCred = MockUserCredential();

    when(
      fbAuth.currentUser,
    ).thenReturn(user);
    when(user.linkWithCredential(any)).thenAnswer((_) async => userCred);

    expect(
      await firebaseAuthRepo.upgradeAnonymousAccount(
        email: testEmail,
        password: testPassword,
      ),
      userCred,
    );
    verify(
      user.linkWithCredential(any),
    ).called(1);
  });

  test(
      'Upgrade anonymous account throws FirebaseAuthException error when user not found',
      () async {
    final fbAuth = MockFirebaseAuth();
    final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);

    when(
      fbAuth.currentUser,
    ).thenReturn(null);

    expect(
      () async => firebaseAuthRepo.upgradeAnonymousAccount(
        email: testEmail,
        password: testPassword,
      ),
      throwsA(isA<FirebaseAuthException>()),
    );
  });

  test('Update user password returns void on success', () {
    final fbAuth = MockFirebaseAuth();
    final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);
    final user = MockUser();

    when(fbAuth.currentUser).thenReturn(user);
    when(user.updatePassword(any)).thenAnswer((_) async => Future<void>);

    firebaseAuthRepo.updateMailPassword(password: testPassword);

    verify(fbAuth.currentUser).called(1);
    verify(user.updatePassword(testPassword)).called(1);
  });

  test(
      'Upgrade password throws FirebaseAuthException error when user not found',
      () async {
    final fbAuth = MockFirebaseAuth();
    final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);

    when(
      fbAuth.currentUser,
    ).thenReturn(null);

    expect(
      () async => firebaseAuthRepo.updateMailPassword(
        password: testPassword,
      ),
      throwsA(isA<FirebaseAuthException>()),
    );
  });

  test('Send password reset request returns void on success', () {
    final fbAuth = MockFirebaseAuth();
    final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);

    when(fbAuth.sendPasswordResetEmail(email: testEmail))
        .thenAnswer((_) async => Future<void>);

    firebaseAuthRepo.sendPasswordResetRequest(email: testEmail);
    verify(fbAuth.sendPasswordResetEmail(email: testEmail)).called(1);
  });

  test('Delete user returns void on success', () async {
    final fbAuth = MockFirebaseAuth();
    final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);
    final User user = MockUser();

    when(fbAuth.currentUser).thenReturn(user);
    when(user.delete()).thenAnswer((_) async => Future<void>);

    await firebaseAuthRepo.deleteAccount();
    verify(fbAuth.currentUser?.delete()).called(1);
    verify(user.delete()).called(1);
  });

  test('Auth state changes returns DanteUser', () {
    final fbAuth = MockFirebaseAuth();
    final firebaseAuthRepo = FirebaseAuthenticationRepository(fbAuth);
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
    when(user.getIdToken()).thenAnswer(
      (_) async => Future<String>.value('authToken'),
    );
    when(user.isAnonymous).thenReturn(false);
    when(user.uid).thenReturn('1');
    when(user.providerData).thenReturn([userInfo]);

    when(fbAuth.authStateChanges()).thenAnswer(
      (_) => Stream.fromIterable(
        [
          null,
          user,
        ],
      ),
    );

    expect(
      firebaseAuthRepo.authStateChanges,
      emitsInOrder(
        [
          null,
          danteUser,
        ],
      ),
    );
  });
}
