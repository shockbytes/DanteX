import 'package:dantex/widgets/statistics/books_and_pages_counts.dart';
import 'package:dantex/widgets/statistics/books_per_month.dart';
import 'package:dantex/widgets/statistics/books_per_year.dart';
import 'package:dantex/widgets/statistics/favorites.dart';
import 'package:dantex/widgets/statistics/label_stats.dart';
import 'package:dantex/widgets/statistics/languages_stats.dart';
import 'package:dantex/widgets/statistics/other_stats.dart';
import 'package:dantex/widgets/statistics/pages_per_month.dart';
import 'package:dantex/widgets/statistics/reading_time.dart';
import 'package:dantex/widgets/statistics/title_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  static String routeName = 'statistics';
  static String routeLocation = '/$routeName';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('statistics.title').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            TitleWidget(
              title: const Text('statistics.books_and_pages.title').tr(),
            ),
            const SizedBox(height: 16),
            const BooksAndPagesCounts(),
            const SizedBox(height: 16),
            TitleWidget(
              title: const Text('statistics.pages_per_month.title').tr(),
            ),
            const SizedBox(height: 16),
            const PagesPerMonth(),
            const SizedBox(height: 16),
            TitleWidget(
              title: const Text('statistics.books_per_month.title').tr(),
            ),
            const SizedBox(height: 16),
            const BooksPerMonth(),
            const SizedBox(height: 16),
            TitleWidget(
              title: const Text('statistics.books_per_year.title').tr(),
            ),
            const SizedBox(height: 16),
            const BooksPerYear(),
            const SizedBox(height: 16),
            TitleWidget(
              title: const Text('statistics.reading_time.title').tr(),
            ),
            const SizedBox(height: 16),
            const ReadingTime(),
            const SizedBox(height: 16),
            TitleWidget(
              title: const Text('statistics.favorites.title').tr(),
            ),
            const SizedBox(height: 16),
            const Favorites(),
            const SizedBox(height: 16),
            TitleWidget(
              title: const Text('statistics.language.title').tr(),
            ),
            const SizedBox(height: 16),
            const LanguagesStats(),
            const SizedBox(height: 16),
            TitleWidget(
              title: const Text('statistics.label.title').tr(),
            ),
            const SizedBox(height: 40),
            const LabelStats(),
            const SizedBox(height: 40),
            TitleWidget(
              title: const Text('statistics.misc.title').tr(),
            ),
            const SizedBox(height: 40),
            const OtherStats(),
          ],
        ),
      ),
    );
  }
}
