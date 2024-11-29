import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/widgets/book_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBookWidget extends ConsumerWidget {
  const AddBookWidget({required this.book, super.key});

  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BookImage(book.thumbnailAddress, size: 80),
        const SizedBox(height: 16),
        Text(
          book.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(book.author),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: OutlinedButton(
                key: const ValueKey('add_book_to_read_later'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ref
                      .read(bookRepositoryProvider)
                      .addBookToState(book, BookState.readLater);
                },
                child: const Text('Read Later').tr(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                key: const ValueKey('add_book_to_reading'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ref
                      .read(bookRepositoryProvider)
                      .addBookToState(book, BookState.reading);
                },
                child: const Text('Reading').tr(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                key: const ValueKey('add_book_to_read'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await ref
                      .read(bookRepositoryProvider)
                      .addBookToState(book, BookState.read);
                },
                child: const Text('Done').tr(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          key: const ValueKey('add_book_to_wishlist'),
          onPressed: () async {
            Navigator.of(context).pop();
            await ref
                .read(bookRepositoryProvider)
                .addBookToState(book, BookState.wishlist);
          },
          child: const Text('Wishlist'),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Not my book'),
        ),
      ],
    );
  }
}
