

import 'package:dantex/com.shockbytes.dante/data/bookdownload/entity/book_suggestion.dart';

abstract class BookDownloader {

  Future<BookSuggestion> downloadBook(String query);
}