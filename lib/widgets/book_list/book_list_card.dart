import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/widgets/book_list/book_actions_bottom_sheet.dart';
import 'package:dantex/widgets/book_list/book_label_button.dart';
import 'package:dantex/widgets/shared/book_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BookListCard extends ConsumerWidget {
  const BookListCard({required this.book, super.key});

  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card.outlined(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: BookImage(book.thumbnailAddress, size: 48),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _BookDetails(book: book),
                  ),
                  _Actions(book: book),
                ],
              ),
              _LabelRow(book: book),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelRow extends StatelessWidget {
  const _LabelRow({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    if (book.labels.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          for (final label in book.labels) BookLabelButton(label: label),
        ],
      ),
    );
  }
}

class _BookDetails extends StatelessWidget {
  const _BookDetails({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (book.subTitle.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              book.subTitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            book.author,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          key: const ValueKey('more_actions_button'),
          onPressed: () async => showModalBottomSheet(
            context: context,
            showDragHandle: true,
            builder: (context) => BookActionsBottomSheet(
              key: const ValueKey('book_actions_bottom_sheet'),
              book: book,
            ),
          ),
          icon: const Icon(Icons.more_vert),
        ),
        if (book.state == BookState.reading) ...[
          CircularPercentIndicator(
            key: ValueKey('book_${book.id}_progress'),
            radius: 20,
            lineWidth: 2,
            percent: book.progressPercentage,
            center: Text(
              '${(book.progressPercentage * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            progressColor: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ],
      ],
    );
  }
}
