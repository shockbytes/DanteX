import 'package:dantex/models/book_label.dart';
import 'package:dantex/util/data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ulid/ulid.dart';

class BookLabelRepository {
  const BookLabelRepository({required DatabaseReference bookLabelDatabase})
      : _bookLabelDatabase = bookLabelDatabase;

  final DatabaseReference _bookLabelDatabase;

  static String labelsPath(String uid) => 'users/$uid/labels';

  Stream<List<BookLabel>> allLabels() {
    return _bookLabelDatabase.onValue.map((event) {
      switch (event.type) {
        case DatabaseEventType.childAdded:
        case DatabaseEventType.childRemoved:
        case DatabaseEventType.childChanged:
        case DatabaseEventType.childMoved:
          // No need to handle these case.
          break;
        case DatabaseEventType.value:
          final data = event.snapshot.toMap();
          final labels = _getLabelsFromDataMap(data);
          return labels;
      }
      return [];
    });
  }

  Future<String> addLabel(BookLabel label) async {
    final labelId = Ulid().toString();
    final labelMap = label.toJson();
    labelMap['id'] = labelId;
    await _bookLabelDatabase.child(labelId).set(labelMap);
    return labelId;
  }

  Future<void> clearLabels() async {
    await _bookLabelDatabase.remove();
  }

  Future<void> deleteLabel(String labelId) async {
    return _bookLabelDatabase.child(labelId).remove();
  }
}

List<BookLabel> _getLabelsFromDataMap(Map<String, dynamic>? data) {
  if (data == null) {
    return [];
  }

  final labels = data.values.map(
    (value) {
      final labelMap = (value as Map<dynamic, dynamic>).cast<String, dynamic>();
      return BookLabel.fromJson(labelMap);
    },
  ).toList();

  return labels;
}
