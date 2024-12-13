import 'package:collection/collection.dart';
import 'package:dantex/models/book.dart';

extension BookListX on Iterable<Book> {
  List<Book> sortedByStartDate() {
    return sorted(
      (a, b) => a.startDate?.compareTo(b.startDate ?? DateTime.now()) ?? -1,
    );
  }
}
