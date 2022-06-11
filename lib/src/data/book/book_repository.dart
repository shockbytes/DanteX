

import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';

abstract class BookRepository {

  Stream<List<Book>> getBooksForState(BookState state);

}