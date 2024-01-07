import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/stats/item_builder/stats_item_builder.dart';
import 'package:dantex/src/data/stats/stats_builder.dart';
import 'package:dantex/src/data/stats/stats_item.dart';

class DefaultStatsBuilder implements StatsBuilder {
  final BookRepository _bookRepository;
  final List<StatsItemBuilder> _itemBuilders;

  DefaultStatsBuilder(this._bookRepository, this._itemBuilders);

  @override
  Stream<List<StatsItem>> buildStats() {
    return _bookRepository.getAllBooks().map(_buildStatsItems);
  }

  List<StatsItem> _buildStatsItems(List<Book> books) {
    return _itemBuilders
        .map(
          (builder) => builder.buildStatsItem(books),
        )
        .toList();
  }
}
