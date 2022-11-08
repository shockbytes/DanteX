import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';

abstract class BookApi {
  Future<BookSuggestion> downloadBook(String query);
}
