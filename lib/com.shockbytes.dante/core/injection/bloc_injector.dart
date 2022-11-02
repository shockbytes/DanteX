import 'package:dantex/com.shockbytes.dante/bloc/add/add_book_bloc.dart';
import 'package:dantex/com.shockbytes.dante/bloc/main/book_state_bloc.dart';
import 'package:dantex/com.shockbytes.dante/data/book/book_repository.dart';
import 'package:dantex/com.shockbytes.dante/data/bookdownload/book_downloader.dart';
import 'package:get/get.dart';


class BlocInjector {
  BlocInjector._();

  static setup() {
    _setupBookStateBloc();
    _setupAddBookBloc();
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

}
