import 'package:dantex/src/bloc/add/add_book_bloc.dart';
import 'package:dantex/src/bloc/login/login_bloc.dart';
import 'package:dantex/src/bloc/main/book_state_bloc.dart';
import 'package:dantex/src/data/authentication/authentication_repository.dart';
import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/bookdownload/book_downloader.dart';
import 'package:get/get.dart';

class BlocInjector {
  BlocInjector._();

  static setup() {
    _setupBookStateBloc();
    _setupAddBookBloc();
    _setupLoginBloc();
  }

  static _setupBookStateBloc() {
    Get.put<BookStateBloc>(
      BookStateBloc(
        Get.find<BookRepository>(),
      ),
      permanent: true,
    );
  }

  static _setupAddBookBloc() {
    Get.put<AddBookBloc>(
      AddBookBloc(
        Get.find<BookDownloader>(),
      ),
      permanent: true,
    );
  }

  static _setupLoginBloc() {
    Get.put<LoginBloc>(
      LoginBloc(
        Get.find<AuthenticationRepository>(),
      ),
      permanent: true,
    );
  }
}
