import 'package:dantex/src/data/book/entity/book.dart';

abstract class SearchCriteria {
  bool fulfillsCriteria(Book book);
}
