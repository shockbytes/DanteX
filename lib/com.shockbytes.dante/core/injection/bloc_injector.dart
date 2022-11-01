import 'package:dantex/com.shockbytes.dante/bloc/main/book_state_bloc.dart';
import 'package:dantex/com.shockbytes.dante/data/book/book_repository.dart';
import 'package:get/get.dart';


class BlocInjector {
  BlocInjector._();

  static setup() {
    _setupBookStateBloc();
  }

  static _setupBookStateBloc() {
    Get.put<BookStateBloc>(
      BookStateBloc(
        Get.find<BookRepository>(),
      ),
      permanent: true,
    );
  }

}
