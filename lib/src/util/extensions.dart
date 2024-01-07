import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:easy_localization/easy_localization.dart';

extension HexColor on String {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color toColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

final DateFormat _dfMonth = DateFormat('MMMM yyyy');
final DateFormat _dfMonthShort = DateFormat('MMM yy');

extension DateTimeX on DateTime {
  String formatWithMonthAndYear() {
    return _dfMonth.format(this);
  }
  String formatWithMonthAndYearShort() {
    return _dfMonthShort.format(this);
  }
}

extension BookListX on Iterable<Book> {
  List<Book> sortedByStartDate() {
    return sorted(
      (a, b) => a.startDate?.compareTo(b.startDate ?? DateTime.now()) ?? -1,
    );
  }

  List<Book> filterReadBooks() {
    return where(
      (book) => book.state == BookState.read && book.endDate != null,
    ).toList();
  }
}
