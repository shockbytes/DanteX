import 'package:dantex/src/bloc/add/add_book_bloc.dart';
import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/bookdownload/book_downloader.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_book_bloc_test.mocks.dart';

@GenerateMocks([
  Book,
  BookDownloader,
  BookRepository,
])
void main() {
  group('Download book', () {
    test('Download valid book', () async {
      final _downloader = MockBookDownloader();
      final _repository = MockBookRepository();
      final _bloc = AddBookBloc(_downloader, _repository);
      const String query = 'Clean Code';
      final target = MockBook();
      final expectedSuggestion = BookSuggestion(target, []);

      when(_downloader.downloadBook(query)).thenAnswer(
            (_) async => expectedSuggestion,
      );

      expect(await _bloc.downloadBook(query), expectedSuggestion);

      verify(_downloader.downloadBook(query)).called(1);
    });

    test('Download book with error', () async {
      final _downloader = MockBookDownloader();
      final _repository = MockBookRepository();
      final _bloc = AddBookBloc(_downloader, _repository);
      const String query = 'Clean Code that does not exist';
      final exception = Exception('No books to view!');

      when(_downloader.downloadBook(query)).thenThrow(exception);

      try {
        await _bloc.downloadBook(query);
        throw Exception('Illegal state - line above must throw exception');
      } catch (e) {
        expect(exception, e);
      }

      verify(_downloader.downloadBook(query)).called(1);
    });
  });

  group('Add book to library', () {
    test('Add book to wishlist', () async {
      final _downloader = MockBookDownloader();
      final _repository = MockBookRepository();
      final _bloc = AddBookBloc(_downloader, _repository);
      final book = _createBook();
      final expectedBook = _createBook(state: BookState.WISHLIST);

      expectLater(
        _bloc.onBookAdded,
        emits(expectedBook),
      );

      _bloc.addToWishlist(book);

      verify(_repository.create(expectedBook)).called(1);
    });

    test('Add book to for later', () async {
      final _downloader = MockBookDownloader();
      final _repository = MockBookRepository();
      final _bloc = AddBookBloc(_downloader, _repository);
      final book = _createBook();
      final expectedBook = _createBook(state: BookState.READ_LATER);

      expectLater(
        _bloc.onBookAdded,
        emits(expectedBook),
      );

      _bloc.addToForLater(book);

      verify(_repository.create(expectedBook)).called(1);
    });

    test('Add book to reading', () async {
      final _downloader = MockBookDownloader();
      final _repository = MockBookRepository();
      final _bloc = AddBookBloc(_downloader, _repository);
      final book = _createBook();
      final expectedBook = _createBook(state: BookState.READING);

      expectLater(
        _bloc.onBookAdded,
        emits(expectedBook),
      );

      _bloc.addToReading(book);

      verify(_repository.create(expectedBook)).called(1);
    });

    test('Add book to read', () async {
      final _downloader = MockBookDownloader();
      final _repository = MockBookRepository();
      final _bloc = AddBookBloc(_downloader, _repository);
      final book = _createBook();
      final expectedBook = _createBook(state: BookState.READ);

      expectLater(
        _bloc.onBookAdded,
        emits(expectedBook),
      );

      _bloc.addToRead(book);

      verify(_repository.create(expectedBook)).called(1);
    });
  });
}

Book _createBook({BookState state = BookState.READING,}) {
  return Book(
    id: '1234',
    title: 'Moby Dick',
    subTitle: '',
    author: 'Herman Melville',
    state: state,
    pageCount: 519,
    currentPage: 0,
    publishedDate: '2022',
    position: 0,
    isbn: '091287389',
    thumbnailAddress: null,
    startDate: 0,
    endDate: 0,
    wishlistDate: 0,
    language: 'en',
    rating: 1,
    notes: 'Notes',
    summary: 'Summary',
    labels: [],
  );
}
