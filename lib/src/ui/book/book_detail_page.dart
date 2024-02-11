import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/providers/book.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/ui/book/add_label_bottom_sheet.dart';
import 'package:dantex/src/ui/book/book_progress_indicator.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/util/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookDetailPage extends ConsumerWidget {
  final String id;

  const BookDetailPage({required this.id, super.key});

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
                  BookProgress(book: book),
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
      error: (error, stackTrace) => GenericErrorWidget(
        error,
        key: const ValueKey('book-detail-error'),
      ),
      loading: () => const CircularProgressIndicator.adaptive(
        key: ValueKey('book-detail-loading'),
      ),
    );
  }
}

class _IconSubtitle extends StatelessWidget {
  final IconData icon;
  final String subtitle;
  final void Function()? onTap;

  const _IconSubtitle({
    required this.icon,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon),
          Text(subtitle),
        ],
      ),
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
            onTap: () async => context.push(
              DanteRoute.bookNotes.navigationUrl.replaceAll(':bookId', book.id),
            ),
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

class _BookLabels extends ConsumerWidget {
  final Book book;

  const _BookLabels({required this.book})
      : super(key: const ValueKey('book-detail-labels'));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        OutlinedButton(
          key: const ValueKey('book-detail-add-label'),
          onPressed: () async {
            await _showAddLabelBottomSheet(context, book.labels);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add),
              Text('book_detail.label'.tr()),
            ],
          ),
        ),
        Row(
          children: [
            ...book.labels.map(
              (bookLabel) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Chip(
                  key: ValueKey('book-label-chip-${bookLabel.title}'),
                  deleteIcon: Icon(
                    Icons.cancel,
                    key: ValueKey('book-label-chip-${bookLabel.title}-delete'),
                  ),
                  deleteIconColor: bookLabel.hexColor.toColor(),
                  padding: const EdgeInsets.symmetric(),
                  onDeleted: () async {
                    await ref
                        .read(bookRepositoryProvider)
                        .removeLabelFromBook(book.id, bookLabel.id);
                  },
                  label: Text(
                    bookLabel.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: bookLabel.hexColor.toColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(
                    side: BorderSide(color: bookLabel.hexColor.toColor()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showAddLabelBottomSheet(
    BuildContext context,
    List<BookLabel> bookLabels,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddLabelBottomSheet(
              book: book,
            ),
          ),
        );
      },
    );
  }
}

class _BookSaveState extends StatelessWidget {
  final Book book;

  const _BookSaveState({required this.book});

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('dd MMM yyyy');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: Visibility(
                  visible: book.forLaterDate != null,
                  child: _IconSubtitle(
                    icon: Icons.bookmark_outline,
                    subtitle:
                        format.format(book.forLaterDate ?? DateTime.now()),
                  ),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: book.startDate != null,
                  child: _IconSubtitle(
                    icon: Icons.book_outlined,
                    subtitle: format.format(book.startDate ?? DateTime.now()),
                  ),
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: book.endDate != null,
                  child: _IconSubtitle(
                    icon: Icons.done_outline_outlined,
                    subtitle: format.format(book.endDate ?? DateTime.now()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
