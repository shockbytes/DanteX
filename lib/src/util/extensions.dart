import 'dart:ui';

import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension BookExtension on Book {
  static Book fromMap(Map<String, dynamic> data) {
    List<BookLabel> labels = [];
    if (data['labels'] != null) {
      data['labels']
          .forEach(
            (v) => labels
                .add(BookLabelExtension.fromMap(v as Map<String, dynamic>)),
          )
          .toList();
    }

    return Book(
      id: data['id'],
      title: data['title'],
      subTitle: data['subTitle'],
      author: data['author'],
      state: BookStateExtension.fromString(data['state']),
      pageCount: data['pageCount'],
      currentPage: data['currentPage'],
      publishedDate: data['publishedDate'],
      position: data['position'],
      isbn: data['isbn'],
      thumbnailAddress: data['thumbnailAddress'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      wishlistDate: data['wishlistDate'],
      language: data['language'],
      rating: data['rating'],
      notes: data['notes'],
      summary: data['summary'],
      labels: labels,
    );
  }
}

extension BookLabelExtension on BookLabel {
  static BookLabel fromMap(Map<String, dynamic> data) {
    return BookLabel(
      bookId: data['bookId'],
      title: data['title'],
      hexColor: data['hexColor'],
    );
  }
}
