import 'dart:ui';

import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';

extension HexColor on String {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color toColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension BookExtension on Map<String, dynamic> {
  Book toBook() {
    final List<BookLabel> labels = [];
    if (this['labels'] != null) {
      this['labels']
          .forEach(
            (v) => labels.add((v as Map<String, dynamic>).toBookLabel()),
          )
          .toList();
    }

    return Book(
      id: this['id'],
      title: this['title'],
      subTitle: this['subTitle'],
      author: this['author'],
      state: this['state'].toString().toBookState(),
      pageCount: this['pageCount'],
      currentPage: this['currentPage'],
      publishedDate: this['publishedDate'],
      position: this['position'],
      isbn: this['isbn'],
      thumbnailAddress: this['thumbnailAddress'],
      startDate: this['startDate'],
      endDate: this['endDate'],
      wishlistDate: this['wishlistDate'],
      language: this['language'],
      rating: this['rating'],
      notes: this['notes'],
      summary: this['summary'],
      labels: labels,
    );
  }
}

extension BookLabelExtension on Map<String, dynamic> {
  BookLabel toBookLabel() {
    return BookLabel(
      bookId: this['bookId'],
      title: this['title'],
      hexColor: this['hexColor'],
    );
  }
}
