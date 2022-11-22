import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
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
    _loginSubject.add(LoginEvent.loggingIn);
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
    _loginSubject.add(LoginEvent.loggingIn);
    _repository.loginAnonymously().then(
      (_) {
        _loginSubject.add(LoginEvent.anonymousLogin);
      },
      onError: (error, stacktrace) {
        _loginSubject.addError(error, stacktrace);
      },
    );
  }

  void loginWithEmail({
    required String email,
    required String password,
  }) {
    _loginSubject.add(LoginEvent.loggingIn);
    _repository.loginWithEmail(email: email, password: password).then(
      (_) {
        _loginSubject.add(LoginEvent.emailLogin);
      },
      onError: (error, stacktrace) {
        _loginSubject.addError(error, stacktrace);
      },
    );
  }

  Future<List<AuthenticationSource>> fetchSignInMethodsForEmail({
    required String email,
  }) async {
    return await _repository.fetchSignInMethodsForEmail(email: email);
  }

  void createAccountWithMail({
    required String email,
    required String password,
  }) {
    _loginSubject.add(LoginEvent.creatingAccount);
    _repository.createAccountWithMail(email: email, password: password).then(
      (_) {
        loginWithEmail(email: email, password: password);
      },
      onError: (error, stacktrace) {
        _loginSubject.addError(error, stacktrace);
      },
    );
  }
}
