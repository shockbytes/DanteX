import 'package:dantex/src/bloc/auth/logout_event.dart';
import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';

class LogoutBloc {
  final AuthenticationRepository _repository;
  final PublishSubject<LogoutEvent> _logoutSubject = PublishSubject();

  Stream<LogoutEvent> get logoutEvents => _logoutSubject.stream;

  LogoutBloc(this._repository);

  void logout() {
    _repository.logout().then(
      (_) {
        _logoutSubject.add(LogoutEvent.logout);
      },
    );
  }
}
