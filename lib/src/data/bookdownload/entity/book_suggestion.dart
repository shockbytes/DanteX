import 'package:dantex/src/data/book/entity/book.dart';

class BookSuggestion {
  final Book target;
  final List<Book> suggestions;

  BookSuggestion(
    this.target,
    this.suggestions,
  );

  bool get hasSuggestions => suggestions.isNotEmpty;
}
