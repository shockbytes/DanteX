import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_label.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/models/dante_language.dart';
import 'package:dantex/models/realm_book.dart';
import 'package:realm/realm.dart';

class RealmBookRepository {
  const RealmBookRepository({required Realm realm}) : _realm = realm;

  final Realm _realm;

  List<Book> list() {
    return _realm
        .all<RealmBook>()
        .where(_hasRealmBookRequiredData)
        .map(
          (rb) => Book(
            id: rb.id.toString(),
            title: rb.title ?? '',
            subTitle: rb.subTitle ?? '',
            author: rb.author ?? '',
            state: BookState.values[rb.ordinalState],
            pageCount: rb.pageCount,
            currentPage: rb.currentPage,
            publishedDate: rb.publishedDate ?? '',
            position: rb.position,
            isbn: rb.isbn!,
            thumbnailAddress: rb.thumbnailAddress,
            startDate: DateTime.fromMillisecondsSinceEpoch(rb.startDate),
            endDate: DateTime.fromMillisecondsSinceEpoch(rb.endDate),
            forLaterDate: DateTime.fromMillisecondsSinceEpoch(rb.wishlistDate),
            language: languageFromIsoCode(rb.language ?? ''),
            rating: rb.rating,
            notes: rb.notes,
            summary: rb.summary,
            googleBooksLink: '',
            labels: rb.labels
                .where(_hasRealmBookLabelRequiredData)
                .map(
                  (rbl) => BookLabel(
                    id: rbl.bookId.toString(),
                    title: rbl.title ?? '',
                    hexColor: rbl.hexColor ?? '',
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }
}

bool _hasRealmBookRequiredData(RealmBook book) {
  return book.id > -1 &&
      book.title != null &&
      book.subTitle != null &&
      book.author != null &&
      book.publishedDate != null &&
      book.language != null;
}

bool _hasRealmBookLabelRequiredData(RealmBookLabel bookLabel) {
  return bookLabel.bookId > -1 &&
      (bookLabel.title?.isNotEmpty ?? false) &&
      (bookLabel.hexColor?.isNotEmpty ?? false);
}
