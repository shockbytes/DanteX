import 'package:dantex/widgets/statistics/books_and_pages_counts.dart';
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
