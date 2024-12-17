import 'package:dantex/models/book.dart';
import 'package:dantex/ui/shared/book_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookSearchListCard extends ConsumerWidget {
  const BookSearchListCard({
    required this.book,
    required this.onTap,
    super.key,
  });

  final Book book;
  final void Function(Book) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card.outlined(
      child: InkWell(
        key: ValueKey('book_${book.id}_search_list_card'),
        borderRadius: BorderRadius.circular(8),
        onTap: () => onTap(book),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              BookImage(book.thumbnailAddress, size: 48),
              const SizedBox(width: 16),
              Expanded(
                child: _BookDetails(book: book),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookDetails extends StatelessWidget {
  const _BookDetails({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          book.author,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
