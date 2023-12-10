
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

/// TODO Required subclasses
/// -[x] Books and Pages
///   -[x] Logic
///   -[x] UI: PieChart
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
/// -[x] Languages
///   -[x] Logic
///   -[x] UI: PieChart
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
/// -[x] Labels
///   -[x] Logic
///   -[x] UI: RadarChart
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
/// -[x] Reading time (fastest, slowest book)
///   -[x] Logic
///   -[x] UI
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
/// -[ ] Favorites (favorite author + first 5 star rating)
///   -[x] Logic
///   -[ ] UI
///   -[ ] Dark Mode
///   -[ ] Mobile Layout
/// -[ ] Misc stats (most read books in month, average books per month)
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
/// -[ ] Books per Year
///   -[x] Logic
///   -[ ] UI
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