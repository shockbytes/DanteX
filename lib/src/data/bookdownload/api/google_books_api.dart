import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/bookdownload/api/book_api.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:dantex/src/data/bookdownload/entity/remote/google_books_response.dart';
import 'package:dio/dio.dart';

class GoogleBooksApi implements BookApi {
  static const _endpoint = 'https://www.googleapis.com/books/v1';

  final Dio _dio = Dio(BaseOptions(baseUrl: _endpoint));

  @override
  Future<BookSuggestion> downloadBook(String query) {
    return _dio.get(
      '/volumes',
      queryParameters: {'q': query},
    ).then((response) {
      final GoogleBooksResponse parsedResponse =
          GoogleBooksResponse.fromJson(response.data);

      if (parsedResponse.items.isEmpty) {
        throw Exception('No books to view!');
      }

      final suggestions = parsedResponse.items.map(_fromItem).toList();

      return BookSuggestion(
        suggestions.first,
        suggestions.sublist(1, suggestions.length),
      );
    });
  }

  Book _fromItem(Items item) {
    final VolumeInfo volumeInfo = item.volumeInfo!;

    return Book(
      id: '-1',
      title: volumeInfo.title ?? '',
      subTitle: volumeInfo.subtitle ?? '',
      author: volumeInfo.authors?.join(', ') ?? '',
      state: BookState.readLater,
      pageCount: volumeInfo.pageCount?.toInt() ?? 0,
      currentPage: 0,
      publishedDate: volumeInfo.publishedDate ?? '',
      position: 0,
      isbn: volumeInfo.industryIdentifiers
              ?.where((ii) => ii.type == 'ISBN_13')
              .map((e) => e.identifier!)
              .join(', ') ??
          '',
      thumbnailAddress: volumeInfo.imageLinks?.thumbnail,
      startDate: null,
      endDate: null,
      forLaterDate: null,
      language: volumeInfo.language ?? 'NA',
      rating: 0,
      notes: '',
      summary: 'TODO Load Description', // TODO
      labels: [],
    );
  }
}
