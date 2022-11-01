import 'book_label.dart';
import 'book_state.dart';

class Book {
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
}
