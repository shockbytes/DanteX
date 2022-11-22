import 'package:dantex/src/bloc/auth/logout_bloc.dart';
import 'package:dantex/src/bloc/auth/logout_event.dart';
import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_bloc_test.mocks.dart';

@GenerateMocks([
  AuthenticationRepository,
])
void main() {
  test('logout emits logout Event', () {
    final _repository = MockAuthenticationRepository();
    final logoutBloc = LogoutBloc(_repository);

    when(_repository.logout()).thenAnswer((_) async => Future<void>);
    logoutBloc.logout();

    expect(
      logoutBloc.logoutEvents,
      emitsInOrder([
        LogoutEvent.logout,
      ]),
    );
    verify(_repository.logout()).called(1);
  });
}
