
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

/// TODO Required subclasses
/// -[x] Books and Pages Diagram (PieChart)
/// -[ ] Pages per Month (including goal)
/// -[ ] Books per Month (including goals)
/// -[ ] Books per Year
/// -[ ] Reading time (fastest, slowest book)
/// -[ ] Favorites (favorite author + first 5 star rating)
/// -[ ] Languages (Pie Chart)
/// -[ ] Labels (RadarChart)
/// -[ ] Book Per Months stats (most read books in month, average books per month)
abstract class StatsItemBuilder {

  StatsItem buildStatsItem(List<Book> books);
}