import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/theme/dante_colors.dart';
import 'package:dantex/ui/add_book/other_books_dialog.dart';
import 'package:dantex/ui/shared/book_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBookWidget extends ConsumerStatefulWidget {
  const AddBookWidget({required this.books, super.key});

  final List<Book> books;

  @override
  ConsumerState<AddBookWidget> createState() => _AddBookWidgetState();
}

class _AddBookWidgetState extends ConsumerState<AddBookWidget> {
  late Book selectedBook;
  late List<Book> otherBooks;

  @override
  void initState() {
    super.initState();
    selectedBook = widget.books.first;
    otherBooks = widget.books.sublist(1);
  }

  @override
  Widget build(BuildContext context) {
    final danteColors = Theme.of(context).extension<DanteColors>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BookImage(selectedBook.thumbnailAddress, size: 80),
        const SizedBox(height: 16),
        Text(
          selectedBook.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(selectedBook.author),
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
                      .addBookToState(selectedBook, BookState.readLater);
                },
                child: Text(
                  'book_state.for_later',
                  style: TextStyle(color: danteColors?.forLaterColor),
                ).tr(),
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
                      .addBookToState(selectedBook, BookState.reading);
                },
                child: Text(
                  'book_state.reading',
                  style: TextStyle(color: danteColors?.readingColor),
                ).tr(),
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
                      .addBookToState(selectedBook, BookState.read);
                },
                child: Text(
                  'book_state.read',
                  style: TextStyle(color: danteColors?.readColor),
                ).tr(),
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
                .addBookToState(selectedBook, BookState.wishlist);
          },
          child: Text(
            'book_state.wishlist',
            style: TextStyle(color: danteColors?.wishlistColor),
          ).tr(),
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          key: const ValueKey('search_other_books'),
          onPressed: () async => showDialog(
            context: context,
            builder: (context) => OtherBooksDialog(
              key: const ValueKey('other_books_dialog'),
              books: otherBooks,
              onTap: (book) {
                setState(() {
                  otherBooks.add(selectedBook);
                  selectedBook = book;
                  otherBooks.remove(book);
                });
              },
            ),
          ),
          child: const Text('search.not_my_book').tr(),
        ),
      ],
    );
  }
}
