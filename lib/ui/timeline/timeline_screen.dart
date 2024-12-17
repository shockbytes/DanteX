import 'package:dantex/providers/service.dart';
import 'package:dantex/providers/timeline.dart';
import 'package:dantex/ui/book_list/no_books_found.dart';
import 'package:dantex/ui/shared/dante_loading_indicator.dart';
import 'package:dantex/ui/timeline/month_entry.dart';
import 'package:dantex/ui/timeline/timeline_sort_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  static String routeName = 'timeline';
  static String routeLocation = '/$routeName';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('timeline.title').tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () async => showDialog<void>(
              context: context,
              builder: (context) => const TimelineSortDialog(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ref.watch(timeLineBooksProvider).when(
              data: (timeLine) {
                if (timeLine.isEmpty) {
                  return const NoBooksFound.timeline();
                }
                return ListView.builder(
                  itemCount: timeLine.length,
                  itemBuilder: (context, index) {
                    final (:month, :books) = timeLine[index];
                    return MonthEntry(month: month, books: books);
                  },
                );
              },
              error: (e, s) {
                ref
                    .read(loggerProvider)
                    .e('Error loading timeline', error: s, stackTrace: s);
                return const SizedBox.shrink();
              },
              loading: () => const Center(
                child: DanteLoadingIndicator(),
              ),
            ),
      ),
    );
  }
}
