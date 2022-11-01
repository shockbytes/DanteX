

import 'package:dantex/com.shockbytes.dante/data/book/book_repository.dart';
import 'package:dantex/com.shockbytes.dante/data/book/entity/book.dart';
import 'package:dantex/com.shockbytes.dante/data/book/entity/book_state.dart';

class BookStateBloc {

  BookRepository _repository;

  BookStateBloc(this._repository);


  Stream<List<Book>> getBooksForState(BookState state) => _repository.getBooksForState(state);



}