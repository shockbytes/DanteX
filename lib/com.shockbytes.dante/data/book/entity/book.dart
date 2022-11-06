import 'package:dantex/com.shockbytes.dante/core/book_core.dart';
import 'package:dantex/com.shockbytes.dante/core/jsonizable.dart';

import 'book_label.dart';
import 'book_state.dart';

class Book with Jsonizable {
  final String id;
  final String title;
  final String subTitle;
  final String author;
  final BookState state;
  final int pageCount;
  final int currentPage;
  final String publishedDate;
  final int position;
  final String isbn;
  final String? thumbnailAddress;
  final int startDate;
  final int endDate;

  /**
   * Actually `forLaterDate` and should not be confused with BookState.WISHLIST. This mishap
   * is due to the initial naming and cannot be changed without breaking prior backups. So, just
   * treat this as `forLaterDate` and everything is fine
   */
  final int wishlistDate;
  final String language;
  final int rating;
  final String? notes;
  final String? summary;
  final List<BookLabel> labels;

  Book({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.author,
    required this.state,
    required this.pageCount,
    required this.currentPage,
    required this.publishedDate,
    required this.position,
    required this.isbn,
    required this.thumbnailAddress,
    required this.startDate,
    required this.endDate,
    required this.wishlistDate,
    required this.language,
    required this.rating,
    required this.notes,
    required this.summary,
    required this.labels,
  });

  @override
  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();

    data['id'] = id;
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['author'] = author;
    data['state'] = state.name;
    data['pageCount'] = pageCount;
    data['currentPage'] = currentPage;
    data['publishedDate'] = publishedDate;
    data['position'] = position;
    data['isbn'] = isbn;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['wishlistDate'] = wishlistDate;
    data['language'] = language;
    data['rating'] = rating;

    if (thumbnailAddress != null) {
      data['thumbnailAddress'] = thumbnailAddress;
    }
    if (notes != null) {
      data['notes'] = notes;
    }
    if (summary != null) {
      data['summary'] = summary;
    }

    data['labels'] = labels.map((label) => label.toMap()).toList();

    return data;
  }

  Book copyWith({
    BookId? newId = null,
    int? newCurrentPage = null
  }) {
    return Book(
      id: newId ?? id,
      title: title,
      subTitle: subTitle,
      author: author,
      state: state,
      pageCount: pageCount,
      currentPage: newCurrentPage ?? currentPage,
      publishedDate: publishedDate,
      position: position,
      isbn: isbn,
      thumbnailAddress: thumbnailAddress,
      startDate: startDate,
      endDate: endDate,
      wishlistDate: wishlistDate,
      language: language,
      rating: rating,
      notes: notes,
      summary: summary,
      labels: labels,
    );
  }
}
