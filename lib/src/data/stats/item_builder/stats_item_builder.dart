
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

/// TODO Required subclasses
/// -[ ] Misc stats (most read books in month, average books per month)
///   -[~] Logic
///   -[ ] UI
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
/// -[ ] Favorites (favorite author + first 5 star rating)
///   -[x] Logic
///   -[ ] UI
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
/// -[ ] Books per Year
///   -[x] Logic
///   -[ ] UI
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
/// -[ ] Books per Month
///   -[ ] Logic
///   -[ ] UI
///   -[ ] Goals
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
/// -[ ] Pages per Month
///   -[ ] Logic
///   -[ ] UI
///   -[ ] Goals
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
abstract class StatsItemBuilder<T extends StatsItem> {

  T buildStatsItem(List<Book> books);
}