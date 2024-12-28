import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_label.dart';
import 'package:dantex/providers/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookLabelChip extends ConsumerWidget {
  const BookLabelChip({required this.label, required this.book, super.key});

  final BookLabel label;
  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Chip(
      label: Text(
        label.title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: label.color,
              fontWeight: FontWeight.bold,
            ),
      ),
      onDeleted: () async =>
          ref.read(bookRepositoryProvider).removeBookLabel(book, label.id),
      deleteIcon: Icon(Icons.close, color: label.color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: BorderSide(
          color: label.color,
        ),
      ),
    );
  }
}
