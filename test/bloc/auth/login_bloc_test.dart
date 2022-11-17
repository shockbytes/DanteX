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

  test('isLoggedIn returns login state', () async {
    final _repository = MockAuthenticationRepository();
    final loginBloc = LoginBloc(_repository);

    when(_repository.getAccount()).thenAnswer(
      (_) async => MockDanteUser(),
    );

    expect(await loginBloc.isLoggedIn(), true);
    verify(_repository.getAccount()).called(1);
  });
}
