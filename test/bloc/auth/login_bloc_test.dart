import 'package:dantex/src/bloc/auth/login_bloc.dart';
import 'package:dantex/src/bloc/auth/login_event.dart';
import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_bloc_test.mocks.dart';

@GenerateMocks([
  AuthenticationRepository,
  DanteUser,
])
void main() {
  const String testEmail = 'test@mail.com';
  const String testPassword = 'password';

  group('Google Login', () {
    test('Login emits Google login event', () async {
      final _repository = MockAuthenticationRepository();
      final loginBloc = LoginBloc(_repository);

      when(_repository.loginWithGoogle()).thenAnswer((_) async => Future<void>);

      expectLater(
        loginBloc.loginEvents,
        emitsInOrder([
          LoginEvent.loggingIn,
          LoginEvent.googleLogin,
        ]),
      );
      loginBloc.loginWithGoogle();

      verify(_repository.loginWithGoogle()).called(1);
    });

    test('Login error emits the same error', () async {
      final _repository = MockAuthenticationRepository();
      final loginBloc = LoginBloc(_repository);
      final exception = FirebaseAuthException(code: '1');

      when(_repository.loginWithGoogle())
          .thenAnswer((_) async => throw exception);

      expectLater(
        loginBloc.loginEvents,
        emitsInOrder([
          LoginEvent.loggingIn,
          emitsError(exception),
        ]),
      );
      loginBloc.loginWithGoogle();

      verify(_repository.loginWithGoogle()).called(1);
    });
  });

  group('Anonymous login', () {
    test('Login emits anonymous login event', () async {
      final _repository = MockAuthenticationRepository();
      final loginBloc = LoginBloc(_repository);

      when(_repository.loginAnonymously())
          .thenAnswer((_) async => Future<void>);

      expectLater(
        loginBloc.loginEvents,
        emitsInOrder([
          LoginEvent.loggingIn,
          LoginEvent.anonymousLogin,
        ]),
      );
      loginBloc.loginAnonymously();

      verify(_repository.loginAnonymously()).called(1);
    });

    test('Login error emits the same error', () async {
      final _repository = MockAuthenticationRepository();
      final loginBloc = LoginBloc(_repository);
      final exception = FirebaseAuthException(code: '1');

      when(_repository.loginAnonymously())
          .thenAnswer((_) async => throw exception);

      expectLater(
        loginBloc.loginEvents,
        emitsInOrder([
          LoginEvent.loggingIn,
          emitsError(exception),
        ]),
      );
      loginBloc.loginAnonymously();

      verify(_repository.loginAnonymously()).called(1);
    });
  });

  group('Email login', () {
    test('Login emits email login event', () async {
      final _repository = MockAuthenticationRepository();
      final loginBloc = LoginBloc(_repository);

      when(_repository.loginWithEmail(email: testEmail, password: testPassword))
          .thenAnswer((_) async => Future<void>);

      expectLater(
        loginBloc.loginEvents,
        emitsInOrder([
          LoginEvent.loggingIn,
          LoginEvent.emailLogin,
        ]),
      );
      loginBloc.loginWithEmail(email: testEmail, password: testPassword);

      verify(
        _repository.loginWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });

    test('Login error emits the same error', () async {
      final _repository = MockAuthenticationRepository();
      final loginBloc = LoginBloc(_repository);
      final exception = FirebaseAuthException(code: '1');

      when(_repository.loginWithEmail(email: testEmail, password: testPassword))
          .thenAnswer((_) async => throw exception);

      expectLater(
        loginBloc.loginEvents,
        emitsInOrder([
          LoginEvent.loggingIn,
          emitsError(exception),
        ]),
      );
      loginBloc.loginWithEmail(email: testEmail, password: testPassword);

      verify(
        _repository.loginWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });

    test('fetchSignInMethodsForEmail returns sign in methods', () async {
      final _repository = MockAuthenticationRepository();
      final loginBloc = LoginBloc(_repository);

      when(_repository.fetchSignInMethodsForEmail(email: testEmail)).thenAnswer(
        (_) async => [AuthenticationSource.google],
      );
      final signInMethods =
          await loginBloc.fetchSignInMethodsForEmail(email: testEmail);

      expect(signInMethods, [AuthenticationSource.google]);
      verify(_repository.fetchSignInMethodsForEmail(email: testEmail))
          .called(1);
    });

    test(
      'Create account emits creating account event then login event',
      () async {
        final _repository = MockAuthenticationRepository();
        final loginBloc = LoginBloc(_repository);

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
          loginBloc.loginEvents,
          emitsInOrder([
            LoginEvent.creatingAccount,
            LoginEvent.loggingIn,
            LoginEvent.emailLogin,
          ]),
        );
        loginBloc.createAccountWithMail(
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
      final loginBloc = LoginBloc(_repository);
      final exception = FirebaseAuthException(code: '1');

      when(
        _repository.createAccountWithMail(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => throw exception);

      expectLater(
        loginBloc.loginEvents,
        emitsInOrder([
          LoginEvent.creatingAccount,
          emitsError(exception),
        ]),
      );
      loginBloc.createAccountWithMail(email: testEmail, password: testPassword);

      verify(
        _repository.createAccountWithMail(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });
  });

  test('isLoggedIn returns login state', () async {
    final _repository = MockAuthenticationRepository();
    final loginBloc = LoginBloc(_repository);

    when(_repository.getAccount()).thenAnswer(
      (_) async => MockDanteUser(),
    );

    expect(await loginBloc.isLoggedIn(), true);
    verify(_repository.getAccount()).called(1);
  });

  test('Get account returns user', () async {
    final _repository = MockAuthenticationRepository();
    final loginBloc = LoginBloc(_repository);
    final user = MockDanteUser();

    when(_repository.getAccount()).thenAnswer(
      (_) async => user,
    );
    when(user.source).thenReturn(AuthenticationSource.anonymous);

    expect(await loginBloc.getAccount(), user);
    verify(_repository.getAccount()).called(1);
  });

  group('Upgrading account', () {
    test('Upgrading anonymous account emits upgrading event then login event',
        () async {
      final _repository = MockAuthenticationRepository();
      final loginBloc = LoginBloc(_repository);

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
        loginBloc.loginEvents,
        emitsInOrder([
          LoginEvent.upgradingAnonymousAccount,
          LoginEvent.loggingIn,
          LoginEvent.emailLogin,
        ]),
      );
      loginBloc.upgradeAnonymousAccount(
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

    test('Create account error emits the same error', () async {
      final _repository = MockAuthenticationRepository();
      final loginBloc = LoginBloc(_repository);
      final exception = FirebaseAuthException(code: '1');

      when(
        _repository.upgradeAnonymousAccount(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => throw exception);

      expectLater(
        loginBloc.loginEvents,
        emitsInOrder([
          LoginEvent.upgradingAnonymousAccount,
          emitsError(exception),
        ]),
      );
      loginBloc.upgradeAnonymousAccount(
        email: testEmail,
        password: testPassword,
      );

      verify(
        _repository.upgradeAnonymousAccount(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });
  });
}
