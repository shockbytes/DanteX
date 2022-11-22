import 'package:dantex/src/data/bookdownload/api/book_api.dart';
import 'package:dantex/src/data/bookdownload/api/google_books_api.dart';
import 'package:get/get.dart';

class ApiInjector {
  ApiInjector._();

  static void setup() {
    _setupBookApiClient();
  }

  static void _setupBookApiClient() {
    Get.put<BookApi>(
      GoogleBooksApi(),
      permanent: true,
    );
  }
}
