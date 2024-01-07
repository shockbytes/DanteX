import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

class LanguageStatsItemBuilder implements StatsItemBuilder<LanguageStatsItem> {
  @override
  LanguageStatsItem buildStatsItem(List<Book> books) {
    final LanguageDataState dataState;
    if (books.isEmpty) {
      dataState = EmptyLanguageData();
    } else {
      dataState = _buildLanguageDataState(books);
    }

    return LanguageStatsItem(dataState);
  }

  LanguageDataState _buildLanguageDataState(List<Book> books) {
    final Map<String, int> distribution = books
        .groupListsBy((e) => e.language)
        .map((key, value) => MapEntry(key, value.length));

    return LanguageData(languageDistribution: distribution);
  }
}
