import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';

class BookStateBloc {
  final BookRepository _repository;

  BookStateBloc(this._repository);

  Stream<List<Book>> getBooksForState(BookState state) =>
      _repository.getBooksForState(state);
}
