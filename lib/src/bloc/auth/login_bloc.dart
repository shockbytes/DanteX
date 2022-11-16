import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'login_event.dart';

class LoginBloc {
  final AuthenticationRepository _repository;
  final PublishSubject<LoginEvent> _loginSubject = PublishSubject();

  LoginBloc(this._repository);

  Stream<LoginEvent> get loginEvents => _loginSubject.stream;

  Future<bool> isLoggedIn() async {
    return (await _repository.getAccount()) != null;
  }

  void loginWithGoogle() {
    _repository.loginWithGoogle().then(
      (_) {
        _loginSubject.add(LoginEvent.googleLogin);
      },
      onError: (error, stacktrace) {
        _loginSubject.addError(error, stacktrace);
      },
    );
  }

  void loginAnonymously() {
    _repository.loginAnonymously().then(
          (value) => {
            print('Logged in anonymously')
            // TODO Update UI
          },
        );
  }

  void loginWithEmail() {
    // TODO
  }
}
