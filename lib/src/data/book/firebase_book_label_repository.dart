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
    final newRef = _labelsRef().push();

    final data = label.copyWith(id: newRef.key!).toJson();

    return newRef.set(data);
  }

  @override
  Future<void> deleteBookLabel(String id) {
    return _labelsRef().child(id).remove();
  }

  @override
  Stream<List<BookLabel>> getBookLabels() {
    return _labelsRef().onValue.map(
      (DatabaseEvent event) {
        final Map<String, dynamic>? data = event.snapshot.toMap();

        if (data == null) {
          return [];
        }

        return data.values.map(
          (value) {
            final Map<String, dynamic> bookMap =
                (value as Map<dynamic, dynamic>).cast();
            return BookLabel.fromJson(bookMap);
          },
        ).toList();
      },
    );
  }

  DatabaseReference _labelsRef() {
    // At this point we can assume that the customer is already logged in, even as anonymous user
    final user = _fbAuth.currentUser!.uid;
    return _fbDb.ref('users/$user/labels/');
  }
}

extension DataSnapshotExtension on DataSnapshot {
  Map<String, dynamic>? toMap() {
    return (value != null) ? (value as Map<dynamic, dynamic>).cast() : null;
  }
}
