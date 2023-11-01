import 'package:dantex/src/data/book/book_label_repository.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseBookLabelRepository implements BookLabelRepository {
  final FirebaseAuth _fbAuth;
  final FirebaseDatabase _fbDb;

  FirebaseBookLabelRepository(this._fbAuth, this._fbDb);

  @override
  Future<void> createBookLabel(BookLabel label) {
    // TODO: implement createBookLabel
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBookLabel(String id) {
    // TODO: implement deleteBookLabel
    throw UnimplementedError();
  }

  @override
  Stream<List<BookLabel>> getBookLabels() {
    // TODO: implement getBookLabels
    throw UnimplementedError();
  }

  DatabaseReference _rootRef() {
    // At this point we can assume that the customer is already logged in, even as anonymous user
    final user = _fbAuth.currentUser!.uid;
    return _fbDb.ref('users/$user/labels');
  }
}

extension DataSnapshotExtension on DataSnapshot {
  Map<String, dynamic>? toMap() {
    return (value != null) ? (value as Map<dynamic, dynamic>).cast() : null;
  }
}
