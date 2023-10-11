import 'package:dantex/src/data/book/entity/book.dart';

abstract class SearchCriteria {
  bool fulfillsCriteria(Book book);
}

/// This implementation takes a look at the most important fields title, subTitle and author
/// and checks if the given [_query] is contained in any of them.
class SimpleQuerySearchCriteria implements SearchCriteria {
  final String _query;

  SimpleQuerySearchCriteria(this._query);

  @override
  bool fulfillsCriteria(Book book) {
    return _checkFieldMatches(
      [
        book.title,
        book.subTitle,
        book.author,
      ],
    );
  }

  bool _checkFieldMatches(List<String> fields) {
    return fields.any(
      (element) => element.toLowerCase().contains(_query.toLowerCase()),
    );
  }
}
