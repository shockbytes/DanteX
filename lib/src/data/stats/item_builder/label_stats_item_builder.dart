import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

class LabelStatsItemBuilder implements StatsItemBuilder<LabelStatsItem> {
  @override
  LabelStatsItem buildStatsItem(List<Book> books) {
    final LabelDataState dataState;
    if (books.isEmpty) {
      dataState = EmptyLabelData();
    } else {
      dataState = _buildLabelDataState(books);
    }

    return LabelStatsItem(dataState);
  }

  LabelDataState _buildLabelDataState(List<Book> books) {
    final Map<String, int> distribution = books
        .map((e) => e.labels)
        .flattened
        .groupListsBy((element) => element.title)
        .map((key, value) => MapEntry(key, value.length));

    if (distribution.isEmpty) {
      return EmptyLabelData();
    }

    return LabelData(labelDistribution: distribution);
  }
}
