import 'package:dantex/src/data/bookdownload/api/book_api.dart';
import 'package:dantex/src/data/bookdownload/book_downloader.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';

class DefaultBookDownloader implements BookDownloader {
  final BookApi _bookApi;

  DefaultBookDownloader(this._bookApi);

  @override
  Future<BookSuggestion> downloadBook(String query) {
    return _bookApi.downloadBook(query);
  }
}
