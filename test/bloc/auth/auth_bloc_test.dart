import 'package:dantex/src/bloc/auth/auth_bloc.dart';
import 'package:dantex/src/bloc/auth/auth_event.dart';
import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([
  AuthenticationRepository,
  DanteUser,
])
void main() {
  const String testEmail = 'test@mail.com';
  const String testPassword = 'password';

  group('Login', () {
    group('Google Login', () {
      test('Login emits Google login event', () async {
        final _repository = MockAuthenticationRepository();
        final authBloc = AuthBloc(_repository);

        when(_repository.loginWithGoogle())
            .thenAnswer((_) async => Future<void>);

        expectLater(
          authBloc.authEvents,
          emitsInOrder([
            AuthEvent.loggingIn,
            AuthEvent.googleLogin,
          ]),
        );
        authBloc.loginWithGoogle();

        verify(_repository.loginWithGoogle()).called(1);
      });

      test('Login error emits the same error', () async {
        final _repository = MockAuthenticationRepository();
        final authBloc = AuthBloc(_repository);
        final exception = FirebaseAuthException(code: '1');

        when(_repository.loginWithGoogle())
            .thenAnswer((_) async => throw exception);

        expectLater(
          authBloc.authEvents,
          emitsInOrder([
            AuthEvent.loggingIn,
            emitsError(exception),
          ]),
        );
        authBloc.loginWithGoogle();

        verify(_repository.loginWithGoogle()).called(1);
      });
    });

    group('Anonymous login', () {
      test('Login emits anonymous login event', () async {
        final _repository = MockAuthenticationRepository();
        final authBloc = AuthBloc(_repository);

        when(_repository.loginAnonymously())
            .thenAnswer((_) async => Future<void>);

        expectLater(
          authBloc.authEvents,
          emitsInOrder([
            AuthEvent.loggingIn,
            AuthEvent.anonymousLogin,
          ]),
        );
        authBloc.loginAnonymously();

        verify(_repository.loginAnonymously()).called(1);
      });

      test('Login error emits the same error', () async {
        final _repository = MockAuthenticationRepository();
        final authBloc = AuthBloc(_repository);
        final exception = FirebaseAuthException(code: '1');

        when(_repository.loginAnonymously())
            .thenAnswer((_) async => throw exception);

        expectLater(
          authBloc.authEvents,
          emitsInOrder([
            AuthEvent.loggingIn,
            emitsError(exception),
          ]),
        );
        authBloc.loginAnonymously();

        verify(_repository.loginAnonymously()).called(1);
      });
    });

    group('Email login', () {
      test('Login emits email login event', () async {
        final _repository = MockAuthenticationRepository();
        final authBloc = AuthBloc(_repository);

        when(
          _repository.loginWithEmail(
            email: testEmail,
            password: testPassword,
          ),
        ).thenAnswer((_) async => Future<void>);

        expectLater(
          authBloc.authEvents,
          emitsInOrder([
            AuthEvent.loggingIn,
            AuthEvent.emailLogin,
          ]),
        );
        authBloc.loginWithEmail(email: testEmail, password: testPassword);

        verify(
          _repository.loginWithEmail(
            email: testEmail,
            password: testPassword,
          ),
        ).called(1);
      });

      test('Login error emits the same error', () async {
        final _repository = MockAuthenticationRepository();
        final authBloc = AuthBloc(_repository);
        final exception = FirebaseAuthException(code: '1');

        when(
          _repository.loginWithEmail(
            email: testEmail,
            password: testPassword,
          ),
        ).thenAnswer((_) async => throw exception);

        expectLater(
          authBloc.authEvents,
          emitsInOrder([
            AuthEvent.loggingIn,
            emitsError(exception),
          ]),
        );
        authBloc.loginWithEmail(email: testEmail, password: testPassword);

        verify(
          _repository.loginWithEmail(
            email: testEmail,
            password: testPassword,
          ),
        ).called(1);
      });

      test('fetchSignInMethodsForEmail returns sign in methods', () async {
        final _repository = MockAuthenticationRepository();
        final authBloc = AuthBloc(_repository);

        when(_repository.fetchSignInMethodsForEmail(email: testEmail))
            .thenAnswer(
          (_) async => [AuthenticationSource.google],
        );
        final signInMethods =
            await authBloc.fetchSignInMethodsForEmail(email: testEmail);

        expect(signInMethods, [AuthenticationSource.google]);
        verify(_repository.fetchSignInMethodsForEmail(email: testEmail))
            .called(1);
      });
    });
  });

  group('Logout', () {
    test('logout emits logout Event', () {
      final _repository = MockAuthenticationRepository();
      final logoutBloc = AuthBloc(_repository);

      when(_repository.logout()).thenAnswer((_) async => Future<void>);
      logoutBloc.logout();

      expect(
        logoutBloc.authEvents,
        emitsInOrder([
          AuthEvent.logout,
        ]),
      );
      verify(_repository.logout()).called(1);
    });
  });

  group('Account management', () {
    test('isLoggedIn returns login state', () async {
      final _repository = MockAuthenticationRepository();
      final authBloc = AuthBloc(_repository);

      when(_repository.getAccount()).thenAnswer(
        (_) async => MockDanteUser(),
      );

      expect(await authBloc.isLoggedIn(), true);
      verify(_repository.getAccount()).called(1);
    });

    test('Get account returns user', () async {
      final _repository = MockAuthenticationRepository();
      final authBloc = AuthBloc(_repository);
      final user = MockDanteUser();

      when(_repository.getAccount()).thenAnswer(
        (_) async => user,
      );
      when(user.source).thenReturn(AuthenticationSource.anonymous);

      expect(await authBloc.getAccount(), user);
      verify(_repository.getAccount()).called(1);
    });

    test('Upgrading anonymous account emits upgrading event then login event',
        () async {
      final _repository = MockAuthenticationRepository();
      final authBloc = AuthBloc(_repository);

      when(
        _repository.upgradeAnonymousAccount(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => Future<void>);
      when(
        _repository.loginWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => Future<void>);

      expectLater(
        authBloc.authEvents,
        emitsInOrder([
          AuthEvent.upgradingAnonymousAccount,
          AuthEvent.loggingIn,
          AuthEvent.emailLogin,
        ]),
      );
      authBloc.upgradeAnonymousAccount(
        email: testEmail,
        password: testPassword,
      );

      await untilCalled(
        _repository.loginWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      );

      verify(
        _repository.upgradeAnonymousAccount(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
      verify(
        _repository.loginWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });

    test(
      'Create account emits creating account event then login event',
      () async {
        final _repository = MockAuthenticationRepository();
        final authBloc = AuthBloc(_repository);

        when(
          _repository.createAccountWithMail(
            email: testEmail,
            password: testPassword,
          ),
        ).thenAnswer((_) async => Future<void>);
        when(
          _repository.loginWithEmail(
            email: testEmail,
            password: testPassword,
          ),
        ).thenAnswer((_) async => Future<void>);

        expectLater(
          authBloc.authEvents,
          emitsInOrder([
            AuthEvent.creatingAccount,
            AuthEvent.loggingIn,
            AuthEvent.emailLogin,
          ]),
        );
        authBloc.createAccountWithMail(
          email: testEmail,
          password: testPassword,
        );

        await untilCalled(
          _repository.loginWithEmail(
            email: testEmail,
            password: testPassword,
          ),
        );

        verify(
          _repository.createAccountWithMail(
            email: testEmail,
            password: testPassword,
          ),
        ).called(1);
        verify(
          _repository.loginWithEmail(
            email: testEmail,
            password: testPassword,
          ),
        ).called(1);
      },
    );

    test('Create account error emits the same error', () async {
      final _repository = MockAuthenticationRepository();
      final authBloc = AuthBloc(_repository);
      final exception = FirebaseAuthException(code: '1');

      when(
        _repository.createAccountWithMail(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => throw exception);

      expectLater(
        authBloc.authEvents,
        emitsInOrder([
          AuthEvent.creatingAccount,
          emitsError(exception),
        ]),
      );
      authBloc.createAccountWithMail(
        email: testEmail,
        password: testPassword,
      );

      verify(
        _repository.createAccountWithMail(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });

    test('Upgrading password emits the same error', () async {
      final _repository = MockAuthenticationRepository();
      final authBloc = AuthBloc(_repository);
      final exception = FirebaseAuthException(code: '1');

      when(
        _repository.updateMailPassword(
          password: testPassword,
        ),
      ).thenAnswer((_) async => throw exception);

      expectLater(
        authBloc.authEvents,
        emitsInOrder([
          AuthEvent.changingPassword,
          emitsError(exception),
        ]),
      );
      authBloc.changePassword(
        password: testPassword,
      );

      verify(
        _repository.updateMailPassword(
          password: testPassword,
        ),
      ).called(1);
    });
  });
}
