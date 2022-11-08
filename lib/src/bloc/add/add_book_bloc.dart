import 'package:dantex/src/data/bookdownload/book_downloader.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';

class AddBookBloc {
  final BookDownloader _downloader;

  AddBookBloc(this._downloader);

  Future<BookSuggestion> downloadBook(String query) {
    return _downloader.downloadBook(query);
  }
}
