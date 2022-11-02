import 'package:dantex/com.shockbytes.dante/data/book/entity/book.dart';

abstract class SearchCriteria {

  bool fulfillsCriteria(Book book);
}
typedef BookId = String;

