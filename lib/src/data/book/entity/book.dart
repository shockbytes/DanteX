import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
class Book with _$Book {
  const Book._();

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
    @Default([]) List<BookLabel> labels,
  }) = _Book;

  factory Book.fromJson(Map<String, Object?> json) => _$BookFromJson(json);

  int get progressPercentage =>
      pageCount != 0 ? ((currentPage / pageCount) * 100).toInt() : 0;

  void addLabel(BookLabel label) {
    labels.add(label);
  }

  void removeLabel(String labelId) {
    labels.removeWhere((label) => label.id == labelId);
  }
}
