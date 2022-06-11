import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';

class DummyBookRepository implements BookRepository {
  @override
  Stream<List<Book>> getBooksForState(BookState state) {
    return Stream.value(_getBooksFromFile());
  }

  List<Book> _getBooksFromFile() {
    return [
      // TODO Load from file
    ];
  }
}
