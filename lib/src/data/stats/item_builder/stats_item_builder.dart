
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

/// TODO Required subclasses
/// -[x] Books and Pages
///   -[x] UI: PieChart
/// -[x] Languages
///   -[x] UI: PieChart
/// -[x] Labels
///   -[x] UI: RadarChart
/// -[x] Reading time (fastest, slowest book)
///   -[x] UI
/// -[ ] Favorites (favorite author + first 5 star rating)
///   -[ ] UI
/// -[ ] Book Per Months stats (most read books in month, average books per month)
///   -[ ] UI
///
/// -[ ] Pages per Month
///   -[ ] UI (including goals)
/// -[ ] Books per Month
///   -[ ] UI (including goals)
/// -[ ] Books per Year
///   -[ ] UI
abstract class StatsItemBuilder<T extends StatsItem> {

  T buildStatsItem(List<Book> books);
}