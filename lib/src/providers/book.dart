import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book.g.dart';

@riverpod
Future<Book> book(BookRef ref, String id) =>
    ref.watch(bookRepositoryProvider).getBook(id);

@riverpod
Stream<List<Book>> booksForState(
  BooksForStateRef ref,
  BookState bookState,
) {
  return ref.watch(bookRepositoryProvider).getBooksForState(bookState);
}
