import 'package:dantex/src/bloc/auth/login_event.dart';
import 'package:dantex/src/bloc/auth/logout_event.dart';
import 'package:dantex/src/bloc/auth/management_event.dart';
import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {
  final AuthenticationRepository _repository;
  final PublishSubject<ManagementEvent> _managementSubject = PublishSubject();
  final PublishSubject<LoginEvent> _loginSubject = PublishSubject();
  final PublishSubject<LogoutEvent> _logoutSubject = PublishSubject();

  AuthBloc(this._repository);

  Stream<ManagementEvent> get managementEvents => _managementSubject.stream;
  Stream<LoginEvent> get loginEvents => _loginSubject.stream;
  Stream<LogoutEvent> get logoutEvents => _logoutSubject.stream;

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
    _managementSubject.add(ManagementEvent.creatingAccount);
    _repository.createAccountWithMail(email: email, password: password).then(
      (_) {
        loginWithEmail(email: email, password: password);
      },
      onError: (error, stacktrace) {
        _managementSubject.addError(error, stacktrace);
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
    _managementSubject.add(ManagementEvent.upgradingAnonymousAccount);
    _repository.upgradeAnonymousAccount(email: email, password: password).then(
      (_) {
        loginWithEmail(email: email, password: password);
      },
      onError: (error, stacktrace) {
        _managementSubject.addError(error, stacktrace);
      },
    );
  }

  void changePassword({required String password}) {
    _managementSubject.add(ManagementEvent.changingPassword);
    _repository.updateMailPassword(password: password).then(
      (_) {},
      onError: (error, stacktrace) {
        _managementSubject.addError(error, stacktrace);
      },
    );
  }

  void logout() {
    _repository.logout().then(
      (_) {
        _logoutSubject.add(LogoutEvent.logout);
      },
    );
  }
}
