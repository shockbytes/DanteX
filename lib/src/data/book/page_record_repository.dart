import 'package:dantex/src/data/book/entity/page_record.dart';

abstract class PageRecordRepository {
  Future<void> insertPageRecordForBookId(
    String bookId,
    int fromPage,
    int toPage,
    int nowInMillis,
  );

  Future<void> updatePageRecord(
    PageRecord pageRecord,
    int? fromPage,
    int? toPage,
  );

  Future<void> deletePageRecordForBook(PageRecord pageRecord);

  Future<void> deleteAllPageRecordsForBookId(String bookId);

  Future<List<PageRecord>> pageRecordsForBook(String bookId);

  Future<List<PageRecord>> allPageRecords();
}
