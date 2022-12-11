import 'package:dantex/src/bloc/add/add_book_bloc.dart';
import 'package:dantex/src/bloc/auth/auth_bloc.dart';
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
    _setupAuthBloc();
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

  static _setupAuthBloc() {
    DependencyInjector.put<AuthBloc>(
      AuthBloc(
        DependencyInjector.get<AuthenticationRepository>(),
      ),
      permanent: true,
    );
  }
}
