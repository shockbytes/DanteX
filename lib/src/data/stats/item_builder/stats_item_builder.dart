
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

abstract class StatsItemBuilder<T extends StatsItem> {

  T buildStatsItem(List<Book> books);
}