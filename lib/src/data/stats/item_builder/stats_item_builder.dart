
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

/// TODO Required subclasses
/// -[x] Books and Pages
///   -[x] Logic
///   -[x] UI: PieChart
/// -[x] Languages
///   -[x] Logic
///   -[x] UI: PieChart
/// -[x] Labels
///   -[x] Logic
///   -[x] UI: RadarChart
/// -[x] Reading time (fastest, slowest book)
///   -[x] Logic
///   -[x] UI
/// -[ ] Favorites (favorite author + first 5 star rating)
///   -[x] Logic
///   -[ ] UI
/// -[ ] Book Per Months stats (most read books in month, average books per month)
///   -[ ] Logic
///   -[ ] UI
/// -[ ] Pages per Month
///   -[ ] Logic
///   -[ ] UI
///   -[ ] Goals
/// -[ ] Books per Month
///   -[ ] Logic
///   -[ ] UI
///   -[ ] Goals
/// -[ ] Books per Year
///   -[ ] Logic
///   -[ ] UI
abstract class StatsItemBuilder<T extends StatsItem> {

  T buildStatsItem(List<Book> books);
}