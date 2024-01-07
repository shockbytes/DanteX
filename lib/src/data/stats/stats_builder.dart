

import 'package:dantex/src/data/stats/stats_item.dart';

abstract class StatsBuilder {

  Stream<List<StatsItem>> buildStats();
}