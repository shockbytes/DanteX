import 'package:dantex/data/book/book_label.dart';
import 'package:dantex/data/book/book_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required String id,
    required String title,
    required String subTitle,
    required String author,
    required BookState state,
    required int pageCount,
    required int currentPage,
    required String publishedDate,
    required int position,
    required String isbn,
    required String? thumbnailAddress,
    required DateTime? startDate,
    required DateTime? endDate,
    required DateTime? forLaterDate,
    required String language,
    required int rating,
    required String? notes,
    required String? summary,
    @Default(<BookLabel>[]) List<BookLabel> labels,
  }) = _Book;

  const Book._();

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  double get progressPercentage {
    if (pageCount == 0) {
      return 0;
    }
    if (currentPage > pageCount) {
      return 1;
    }

    return currentPage / pageCount;
  }
}
