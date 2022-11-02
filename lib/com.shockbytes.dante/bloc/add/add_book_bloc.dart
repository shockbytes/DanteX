
import 'package:dantex/com.shockbytes.dante/data/bookdownload/book_downloader.dart';
import 'package:dantex/com.shockbytes.dante/data/bookdownload/entity/book_suggestion.dart';

class AddBookBloc {

  final BookDownloader _downloader;

  AddBookBloc(this._downloader);

  Future<BookSuggestion> downloadBook(String query) {
    return _downloader.downloadBook(query);
  }

}