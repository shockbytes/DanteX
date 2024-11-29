import 'package:dantex/models/book.dart';
import 'package:dantex/widgets/add_book/book_search_list_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OtherBooksDialog extends StatelessWidget {
  const OtherBooksDialog({required this.books, required this.onTap, super.key});

  final void Function(Book) onTap;
  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('add_book.other_books').tr(),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return BookSearchListCard(
              book: book,
              onTap: (book) {
                onTap(book);
                Navigator.of(context).pop();
              },
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8);
          },
        ),
      ),
    );
  }
}
