import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/providers/settings.dart';
import 'package:dantex/ui/book_detail/book_progress_widget.dart';
import 'package:dantex/ui/edit_book/edit_book_screen.dart';
import 'package:dantex/ui/shared/book_image.dart';
import 'package:dantex/ui/shared/dante_loading_indicator.dart';
import 'package:dantex/ui/shared/expandable_text.dart';
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
            child: SingleChildScrollView(
              child: Column(
                spacing: 8,
                children: [
                  const SizedBox(height: 8),
                  BookImage(book.thumbnailAddress, size: 96),
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    book.author,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (showBookSummary && summary != null) ...[
                    const SizedBox(height: 8),
                    ExpandableText(
                      text: summary,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 8),
                  BookProgressWidget(book: book),
                ],
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
