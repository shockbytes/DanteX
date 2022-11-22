import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';

abstract class BookDownloader {
  Future<BookSuggestion> downloadBook(String query);
}
