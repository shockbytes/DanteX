import 'package:dantex/src/bloc/auth/auth_event.dart';
import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {
  final AuthenticationRepository _repository;
  final PublishSubject<AuthEvent> _authSubject = PublishSubject();

  AuthBloc(this._repository);

  Stream<AuthEvent> get authEvents => _authSubject.stream;

  Future<bool> isLoggedIn() async {
    return (await _repository.getAccount()) != null;
  }

  void loginWithGoogle() {
    _authSubject.add(AuthEvent.loggingIn);
    _repository.loginWithGoogle().then(
      (_) {
        _authSubject.add(AuthEvent.googleLogin);
      },
      onError: (error, stacktrace) {
        _authSubject.addError(error, stacktrace);
      },
    );
  }

  void loginAnonymously() {
    _authSubject.add(AuthEvent.loggingIn);
    _repository.loginAnonymously().then(
      (_) {
        _authSubject.add(AuthEvent.anonymousLogin);
      },
      onError: (error, stacktrace) {
        _authSubject.addError(error, stacktrace);
      },
    );
  }

  void loginWithEmail({
    required String email,
    required String password,
  }) {
    _authSubject.add(AuthEvent.loggingIn);
    _repository.loginWithEmail(email: email, password: password).then(
      (_) {
        _authSubject.add(AuthEvent.emailLogin);
      },
      onError: (error, stacktrace) {
        _authSubject.addError(error, stacktrace);
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
    _authSubject.add(AuthEvent.creatingAccount);
    _repository.createAccountWithMail(email: email, password: password).then(
      (_) {
        loginWithEmail(email: email, password: password);
      },
      onError: (error, stacktrace) {
        _authSubject.addError(error, stacktrace);
      },
    );
  }

  Future<DanteUser?> getAccount() async {
    return _repository.getAccount();
  }

  void upgradeAnonymousAccount({
    required String email,
    required String password,
  }) {
    _authSubject.add(AuthEvent.upgradingAnonymousAccount);
    _repository.upgradeAnonymousAccount(email: email, password: password).then(
      (_) {
        loginWithEmail(email: email, password: password);
      },
      onError: (error, stacktrace) {
        _authSubject.addError(error, stacktrace);
      },
    );
  }

  void changePassword({required String password}) {
    _authSubject.add(AuthEvent.changingPassword);
    _repository.updateMailPassword(password: password).then(
      (_) {},
      onError: (error, stacktrace) {
        _authSubject.addError(error, stacktrace);
      },
    );
  }

  void logout() {
    _repository.logout().then(
      (_) {
        _authSubject.add(AuthEvent.logout);
      },
    );
  }
}
