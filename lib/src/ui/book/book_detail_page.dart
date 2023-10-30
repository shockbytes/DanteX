import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/providers/book.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/util/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BookDetailPage extends ConsumerWidget {
  final String id;

  const BookDetailPage({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookProvider(id));

    return book.when(
      data: (book) {
        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            title: Text(
              book.title,
              key: const ValueKey('book-detail-app-bar-title'),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: Implement edit book
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  _BookInfo(book: book),
                  const SizedBox(height: 20),
                  _BookProgress(book: book),
                  const SizedBox(height: 20),
                  _BookActions(book: book),
                  const SizedBox(height: 20),
                  _BookLabels(book: book),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _BookSaveState(book: book),
        );
      },
      error: (error, stackTrace) => GenericErrorWidget(error),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }
}

class _IconSubtitle extends StatelessWidget {
  final IconData icon;
  final String subtitle;

  const _IconSubtitle({required this.icon, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        Text(subtitle),
      ],
    );
  }
}

class _BookInfo extends StatelessWidget {
  final Book book;

  const _BookInfo({required this.book})
      : super(key: const ValueKey('book-detail-info'));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            key: const ValueKey('book-detail-image'),
            imageUrl: book.thumbnailAddress!,
            width: 80,
          ),
        ),
        Text(
          key: const ValueKey('book-detail-title'),
          book.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        Text(
          book.subTitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          book.author,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        // TODO: Add collapseable text field for description here
      ],
    );
  }
}

class _BookProgress extends StatelessWidget {
  final Book book;

  const _BookProgress({required this.book});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: book.pageCount > 0,
      child: SizedBox(
        height: 140,
        child: CircularPercentIndicator(
          key: const ValueKey('book-detail-progress-indicator'),
          radius: 70.0,
          lineWidth: 2.0,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          widgetIndicator: Icon(
            Icons.circle,
            size: 12,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          percent: book.currentPage / book.pageCount,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_outlined,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              const SizedBox(height: 8),
              Text(
                '${book.currentPage} / ${book.pageCount}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          progressColor: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

class _BookActions extends StatelessWidget {
  final Book book;

  const _BookActions({required this.book})
      : super(key: const ValueKey('book-detail-actions'));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _IconSubtitle(
            icon: Icons.star,
            subtitle: 'book_detail.rate'.tr(),
          ),
        ),
        Expanded(
          child: _IconSubtitle(
            icon: Icons.assignment,
            subtitle: 'book_detail.notes'.tr(),
          ),
        ),
        Expanded(
          child: _IconSubtitle(
            icon: Icons.today,
            subtitle: book.publishedDate,
          ),
        ),
      ],
    );
  }
}

class _BookLabels extends StatelessWidget {
  final Book book;

  const _BookLabels({required this.book})
      : super(key: const ValueKey('book-detail-labels'));

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
          key: const ValueKey('book-detail-add-label'),
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add),
              Text('book_detail.label'.tr()),
            ],
          ),
        ),
        ...book.labels.map(
          (bookLabel) => Chip(
            key: ValueKey('book-label-chip-${bookLabel.title}'),
            color: MaterialStateProperty.all(bookLabel.hexColor.toColor()),
            label: Text(bookLabel.title),
          ),
        ),
      ],
    );
  }
}

class _BookSaveState extends StatelessWidget {
  final Book book;

  const _BookSaveState({required this.book});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _IconSubtitle(
                icon: Icons.bookmark_outline,
                subtitle: book.wishlistDate.toString(),
              ),
              // TODO: Add other save states here
            ],
          ),
        ),
      ),
    );
  }
}
