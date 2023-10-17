import 'package:dantex/src/data/book/entity/page_record.dart';
import 'package:dantex/src/data/book/page_record_repository.dart';
import 'package:dantex/src/data/book/realm/realm_book.dart';
import 'package:realm/realm.dart';

class RealmPageRecordRepository implements PageRecordRepository {
  final Realm _realm;

  RealmPageRecordRepository(this._realm);

  @override
  Future<List<PageRecord>> allPageRecords() async {
    return _realm
        .all<RealmPageRecord>()
        .where(_hasPageRecordRequiredData)
        .map(
          (rpg) => PageRecord(
            bookId: rpg.bookId.toString(),
            fromPage: rpg.fromPage,
            toPage: rpg.toPage,
            timestamp: rpg.timestamp,
          ),
        )
        .toList();
  }

  bool _hasPageRecordRequiredData(RealmPageRecord pageRecord) {
    return pageRecord.bookId != -1 && pageRecord.timestamp != 0;
  }

  @override
  Future<void> deleteAllPageRecordsForBookId(String bookId) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> deletePageRecordForBook(PageRecord pageRecord) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> insertPageRecordForBookId(
    String bookId,
    int fromPage,
    int toPage,
    int nowInMillis,
  ) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<List<PageRecord>> pageRecordsForBook(String bookId) {
    // Not required.
    throw UnimplementedError();
  }

  @override
  Future<void> updatePageRecord(
    PageRecord pageRecord,
    int? fromPage,
    int? toPage,
  ) {
    // Not required.
    throw UnimplementedError();
  }
}
