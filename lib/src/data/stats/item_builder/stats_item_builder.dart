
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

/// TODO Required subclasses
/// -[ ] BUG WHEN MOVING BOOKS BETWEEN STATES
/// -[ ] Books per Year
///   -[x] Logic
///   -[ ] UI
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
/// -[ ] Books per Month
///   -[x] Logic
///   -[ ] UI
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
/// -[ ] Update pub dependencies
///
/// TODO: OWN TICKET BC OF PAGE REPOSITORY
/// -[ ] Pages per Month
///   -[ ] Logic
///   -[ ] UI
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
///
/// -[ ] Books per Month
///   -[ ] Goals
/// -[ ] Pages per Month
///   -[ ] Goals
abstract class StatsItemBuilder<T extends StatsItem> {

  T buildStatsItem(List<Book> books);
}