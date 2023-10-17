import 'package:dantex/src/data/book/entity/page_record.dart';
import 'package:dantex/src/data/book/page_record_repository.dart';

// TODO Implement this class
class RealmPageRecordRepository implements PageRecordRepository {
  @override
  Future<List<PageRecord>> allPageRecords() {
    // TODO: implement allPageRecords
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllPageRecordsForBookId(String bookId) {
    // TODO: implement deleteAllPageRecordsForBookId
    throw UnimplementedError();
  }

  @override
  Future<void> deletePageRecordForBook(PageRecord pageRecord) {
    // TODO: implement deletePageRecordForBook
    throw UnimplementedError();
  }

  @override
  Future<void> insertPageRecordForBookId(
    String bookId,
    int fromPage,
    int toPage,
    int nowInMillis,
  ) {
    // TODO: implement insertPageRecordForBookId
    throw UnimplementedError();
  }

  @override
  Future<List<PageRecord>> pageRecordsForBook(String bookId) {
    // TODO: implement pageRecordsForBook
    throw UnimplementedError();
  }

  @override
  Future<void> updatePageRecord(
      PageRecord pageRecord, int? fromPage, int? toPage) {
    // TODO: implement updatePageRecord
    throw UnimplementedError();
  }
}
