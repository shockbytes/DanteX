import 'package:dantex/com.shockbytes.dante/data/book/book_repository.dart';
import 'package:dantex/com.shockbytes.dante/data/book/dummy_book_repository.dart';
import 'package:get/get.dart';

class RepositoryInjector {
  RepositoryInjector._();

  static setup() {
    _setupBookRepository();
  }

  static _setupBookRepository() {
    Get.put<BookRepository>(
      DummyBookRepository(),
      permanent: true,
    );
  }

}
