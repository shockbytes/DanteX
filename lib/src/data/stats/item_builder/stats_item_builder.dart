
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

/// TODO Required subclasses
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
/// -[ ] BUG WHEN MOVING BOOKS
abstract class StatsItemBuilder<T extends StatsItem> {

  T buildStatsItem(List<Book> books);
}