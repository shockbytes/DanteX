import 'package:dantex/com.shockbytes.dante/data/book/book_repository.dart';
import 'package:dantex/com.shockbytes.dante/data/book/entity/book.dart';
import 'package:dantex/com.shockbytes.dante/data/book/entity/book_label.dart';
import 'package:dantex/com.shockbytes.dante/data/book/entity/book_state.dart';

class DummyBookRepository implements BookRepository {
  @override
  Stream<List<Book>> getBooksForState(BookState state) {
    return Stream.value(_getBooks(state));
  }

  List<Book> _getBooks(BookState state) {
    return List.generate(16, (index) => _getBook(state));
  }

  Book _getBook(BookState state) {
    return Book(
      id: '1',
      title: 'La Divina Comedia',
      subTitle: 'Best book',
      author: 'Dante Aleghri',
      state: state,
      pageCount: 600,
      currentPage: 240,
      publishedDate: '2022-10-20',
      position: 0,
      isbn: '9283902939',
      thumbnailAddress: 'https://m.media-amazon.com/images/I/51hpvxtvT4L._SY264_BO1,204,203,200_QL40_ML2_.jpg',
      startDate: 0,
      endDate: 0,
      wishlistDate: DateTime.now().millisecondsSinceEpoch,
      language: 'en',
      rating: 5,
      notes: 'Best book ever!',
      summary: 'A divine comedy book',
      labels: [
        BookLabel(
          bookId: '1',
          title: 'Classics',
          hexColor: '#aaddee',
        ),
        BookLabel(
          bookId: '2',
          title: 'Programming',
          hexColor: '#aaddee',
        ),
        BookLabel(
          bookId: '3',
          title: 'Stoicism',
          hexColor: '#aaddee',
        ),
        BookLabel(
          bookId: '4',
          title: 'Philosophy',
          hexColor: '#FF0000',
        ),
        BookLabel(
          bookId: '5',
          title: 'Philosophy',
          hexColor: '#FF0000',
        ),
      ],
    );
  }
}
