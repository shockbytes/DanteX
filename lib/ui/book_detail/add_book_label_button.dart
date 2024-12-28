import 'package:dantex/models/book.dart';
import 'package:dantex/ui/book_detail/add_book_label_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddBookLabelButton extends StatelessWidget {
  const AddBookLabelButton({required this.book, super.key});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        icon: const Icon(Icons.add),
        onPressed: () async => showModalBottomSheet(
          showDragHandle: true,
          context: context,
          builder: (context) => AddBookLabelBottomSheet(
            key: const ValueKey('add_book_label_dialog'),
            book: book,
          ),
        ),
        label: Text(
          'book_detail.label',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ).tr(),
      ),
    );
  }
}
