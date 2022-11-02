

import 'package:dantex/com.shockbytes.dante/data/book/entity/book.dart';

typedef BookId = String;

abstract class SearchCriteria {

  bool fulfillsCriteria(Book book);
}