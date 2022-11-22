import 'package:dantex/src/bloc/add/add_book_bloc.dart';
import 'package:dantex/src/bloc/auth/login_bloc.dart';
import 'package:dantex/src/bloc/auth/logout_bloc.dart';
import 'package:dantex/src/bloc/main/book_state_bloc.dart';
import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/bookdownload/book_downloader.dart';

class BlocInjector {
  BlocInjector._();

  static setup() {
    _setupBookStateBloc();
    _setupAddBookBloc();
    _setupLoginBloc();
    _setupLogoutBloc();
  }

  static _setupBookStateBloc() {
    DependencyInjector.put<BookStateBloc>(
      BookStateBloc(
        DependencyInjector.get<BookRepository>(),
      ),
      permanent: true,
    );
  }

  static _setupAddBookBloc() {
    DependencyInjector.put<AddBookBloc>(
      AddBookBloc(
        DependencyInjector.get<BookDownloader>(),
        DependencyInjector.get<BookRepository>(),
      ),
      permanent: true,
    );
  }

  static _setupLoginBloc() {
    DependencyInjector.put<LoginBloc>(
      LoginBloc(
        DependencyInjector.get<AuthenticationRepository>(),
      ),
      permanent: true,
    );
  }

  static _setupLogoutBloc() {
    DependencyInjector.put<LogoutBloc>(
      LogoutBloc(
        DependencyInjector.get<AuthenticationRepository>(),
      ),
      permanent: true,
    );
  }
}
