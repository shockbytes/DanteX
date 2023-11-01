import 'package:dantex/src/data/book/entity/page_record.dart';
import 'package:dantex/src/data/book/firebase_utils.dart';
import 'package:dantex/src/data/book/page_record_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebasePageRecordRepository implements PageRecordRepository {
  final FirebaseAuth _fbAuth;
  final FirebaseDatabase _fbDb;

  FirebasePageRecordRepository(this._fbAuth, this._fbDb);

  @override
  Future<List<PageRecord>> allPageRecords() {
    return _rootRef().get().then(_fromDataSnapshot);
  }

  @override
  Future<void> deleteAllPageRecordsForBookId(String bookId) async {
    final List<PageRecord> records = await pageRecordsForBook(bookId);
    records.forEach(deletePageRecord);
  }

  @override
  Future<void> deletePageRecord(PageRecord pageRecord) async {
    await _rootRef().child(pageRecord.id).remove();
  }

  @override
  Future<void> insertPageRecordForBookId(
    String bookId,
    int fromPage,
    int toPage,
    DateTime now,
  ) async {
    final DatabaseReference newRef = _rootRef().push();

    final Map<String, dynamic> data = PageRecord(
      id: newRef.key!,
      bookId: bookId,
      fromPage: fromPage,
      toPage: toPage,
      dateTime: now,
    ).toJson();

    return newRef.set(data);
  }

  @override
  Future<List<PageRecord>> pageRecordsForBook(String bookId) async {
    return _rootRef()
        .equalTo('bookId', key: bookId)
        .get()
        .then(_fromDataSnapshot);
  }

  @override
  Future<void> updatePageRecord(
    PageRecord pageRecord,
    int? fromPage,
    int? toPage,
  ) {
    return _rootRef().child(pageRecord.id).set(
      pageRecord.copyWith(
        // Use currently set values, if values are null.
        fromPage: fromPage ?? pageRecord.fromPage,
        toPage: toPage ?? pageRecord.toPage,
      ),
    );
  }

  List<PageRecord> _fromDataSnapshot(DataSnapshot snapshot) {
    final Map<String, dynamic>? data = snapshot.toMap();

    if (data == null) {
      return [];
    }

    return data
        .map(
          (key, value) {
            final Map<String, dynamic> pageRecordMap =
                (value as Map<dynamic, dynamic>).cast();
            final PageRecord pageRecord = PageRecord.fromJson(pageRecordMap);
            return MapEntry(key, pageRecord);
          },
        )
        .values
        .toList();
  }

  DatabaseReference _rootRef() {
    // At this point we can assume that the customer is already logged in,
    // even as anonymous user
    final user = _fbAuth.currentUser!.uid;
    return _fbDb.ref('users/$user/page-records');
  }
}

