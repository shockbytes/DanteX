import 'package:dantex/src/bloc/auth/login_bloc.dart';
import 'package:dantex/src/bloc/auth/login_event.dart';
import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_bloc_test.mocks.dart';

@GenerateMocks([
  AuthenticationRepository,
  DanteUser,
])
void main() {
  test('loginWithGoogle emits googleLogin Event', () {
    final _repository = MockAuthenticationRepository();
    final loginBloc = LoginBloc(_repository);

    when(_repository.loginWithGoogle()).thenAnswer((_) async => Future<void>);
    loginBloc.loginWithGoogle();

    expect(
      loginBloc.loginEvents,
      emitsInOrder([
        LoginEvent.googleLogin,
      ]),
    );
    verify(_repository.loginWithGoogle()).called(1);
  });

  test('loginWithGoogle error emits the same error', () {
    final _repository = MockAuthenticationRepository();
    final loginBloc = LoginBloc(_repository);
    final error = ArgumentError();

    when(_repository.loginWithGoogle()).thenAnswer((_) async => throw error);
    loginBloc.loginWithGoogle();

    expect(
      loginBloc.loginEvents,
      emitsError(error),
    );
    verify(_repository.loginWithGoogle()).called(1);
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
