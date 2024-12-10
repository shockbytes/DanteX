import 'package:dantex/models/book.dart';
import 'package:dantex/util/string_utilities.dart';

enum BookSortStrategy {
  position(
    strategyName: 'Position (default)',
  ),
  author(
    strategyName: 'Author',
  ),
  title(
    strategyName: 'Title',
  ),
  progress(
    strategyName: 'Progress',
  ),
  pages(
    strategyName: 'Pages',
  ),
  labels(
    strategyName: 'Labels',
  );

  const BookSortStrategy({required this.strategyName});
  final String strategyName;

  Comparator<Book> comparator() {
    return switch (this) {
      BookSortStrategy.position => (Book a, Book b) =>
          a.position.compareTo(b.position),
      BookSortStrategy.author => (Book a, Book b) =>
          _getSurname(a.author).compareTo(_getSurname(b.author)),
      BookSortStrategy.title => (Book a, Book b) =>
          _sanitizeTitle(a.title).compareTo(_sanitizeTitle(b.title)),
      BookSortStrategy.progress => (Book a, Book b) =>
          a.progressPercentage.compareTo(b.progressPercentage),
      BookSortStrategy.pages => (Book a, Book b) =>
          a.pageCount.compareTo(b.pageCount),
      BookSortStrategy.labels => (Book a, Book b) =>
          (a.labels.firstOrNull?.title ?? '')
              .compareTo(b.labels.firstOrNull?.title ?? ''),
    };
  }

  String _getSurname(String author) {
    // Multiple authors
    String primaryAuthor;
    if (author.contains(',')) {
      primaryAuthor = author.split(',')[0].removeBrackets();
    } else {
      primaryAuthor = author;
    }

    // Author has several names
    if (primaryAuthor.contains(' ')) {
      return primaryAuthor.split(' ').last;
    } else {
      return primaryAuthor;
    }
  }

  String _sanitizeTitle(String title) {
    // Maybe introduce more sanitization rules later on.
    return title.toLowerCase();
  }
}
