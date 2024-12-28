import 'package:dantex/models/book.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/providers/settings.dart';
import 'package:dantex/theme/dante_colors.dart';
import 'package:dantex/ui/book_detail/add_book_label_button.dart';
import 'package:dantex/ui/book_detail/book_label_chip.dart';
import 'package:dantex/ui/book_detail/book_progress_widget.dart';
import 'package:dantex/ui/book_detail/edit_page_record_dialog.dart';
import 'package:dantex/ui/book_detail/notes_screen.dart';
import 'package:dantex/ui/book_detail/page_record_action.dart';
import 'package:dantex/ui/book_detail/rate_book_dialog.dart';
import 'package:dantex/ui/book_detail/reading_behavior.dart';
import 'package:dantex/ui/book_detail/reset_page_record_dialog.dart';
import 'package:dantex/ui/edit_book/edit_book_screen.dart';
import 'package:dantex/ui/shared/book_image.dart';
import 'package:dantex/ui/shared/dante_loading_indicator.dart';
import 'package:dantex/ui/shared/expandable_text.dart';
import 'package:dantex/ui/shared/subtitle_icon.dart';
import 'package:dantex/util/date_time.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({required this.bookId, super.key});

  final String bookId;

  static String get routeName => 'book';
  static String get routeLocation => '/$routeName/:bookId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookProvider(bookId));

    return book.when(
      data: (book) {
        if (book == null) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: const Text('book_detail.not_found').tr(),
            ),
          );
        }

        final showBookSummary = ref.watch(showBookSummarySettingProvider);
        final summary = book.summary;

        return Scaffold(
          appBar: AppBar(
            title: Text(book.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async => context.push(
                  EditBookScreen.routeLocation.replaceAll(
                    ':bookId',
                    book.id,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              children: [
                const SizedBox(height: 16),
                BookImage(book.thumbnailAddress, size: 96),
                const SizedBox(height: 8),
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  book.author,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                if (showBookSummary && summary != null) ...[
                  const SizedBox(height: 16),
                  ExpandableText(
                    text: summary,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 16),
                BookProgressWidget(book: book),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () async => showDialog(
                          context: context,
                          builder: (context) => RateBookDialog(book: book),
                        ),
                        icon: SubtitleIcon(
                          icon: Icons.star_outline,
                          subtitle: book.rating != 0
                              ? 'book_detail.rating'
                                  .tr(args: [book.rating.toString()])
                              : 'book_detail.rate'.tr(),
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () async => context.push(
                          NotesScreen.navigationUrl.replaceAll(
                            ':bookId',
                            book.id,
                          ),
                        ),
                        icon: SubtitleIcon(
                          icon: Icons.assignment_outlined,
                          subtitle: 'book_detail.notes'.tr(),
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {},
                        icon: SubtitleIcon(
                          icon: Icons.event_outlined,
                          subtitle: book.startDate?.formatWithDayMonthYear() ??
                              book.forLaterDate?.formatWithDayMonthYear() ??
                              '',
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                if (book.pageRecords.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('book_detail.reading_behavior').tr(),
                      const Spacer(),
                      PopupMenuButton<PageRecordAction>(
                        icon: const Icon(Icons.more_horiz),
                        onSelected: (action) async => _handlePageRecordAction(
                          context,
                          action,
                          book,
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: PageRecordAction.edit,
                            child: Row(
                              children: [
                                const Icon(Icons.edit_outlined),
                                const SizedBox(width: 8),
                                const Text('book_detail.edit').tr(),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: PageRecordAction.reset,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                const Text('book_detail.reset').tr(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ReadingBehavior(pageRecords: book.pageRecords),
                ],
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 8,
                    children: [
                      AddBookLabelButton(book: book),
                      ...book.labels.map(
                        (bookLabel) => BookLabelChip(
                          key: ValueKey(bookLabel.id),
                          book: book,
                          label: bookLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Visibility(
                        visible: book.forLaterDate != null,
                        child: SubtitleIcon(
                          icon: Icons.bookmark_outline,
                          subtitle:
                              book.forLaterDate?.formatWithDayMonthYear() ?? '',
                          size: 24,
                          iconColor: Theme.of(context)
                              .extension<DanteColors>()
                              ?.forLaterColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Visibility(
                        visible: book.startDate != null,
                        child: SubtitleIcon(
                          icon: Icons.book_outlined,
                          subtitle:
                              book.startDate?.formatWithDayMonthYear() ?? '',
                          size: 24,
                          iconColor: Theme.of(context)
                              .extension<DanteColors>()
                              ?.readingColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Visibility(
                        visible: book.endDate != null,
                        child: SubtitleIcon(
                          icon: Icons.done_outline_outlined,
                          subtitle:
                              book.endDate?.formatWithDayMonthYear() ?? '',
                          size: 24,
                          iconColor: Theme.of(context)
                              .extension<DanteColors>()
                              ?.readColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (e, s) {
        ref
            .read(loggerProvider)
            .e('Failed to load book', error: e, stackTrace: s);

        return const Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('Failed to load book'),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: DanteLoadingIndicator(),
        ),
      ),
    );
  }
}

Future<void> _handlePageRecordAction(
  BuildContext context,
  PageRecordAction action,
  Book book,
) async {
  switch (action) {
    case PageRecordAction.edit:
      await showDialog<void>(
        context: context,
        builder: (context) => EditPageRecordDialog(bookId: book.id),
      );
    case PageRecordAction.reset:
      await showDialog<void>(
        context: context,
        builder: (context) => ResetPageRecordDialog(bookId: book.id),
      );
  }
}
