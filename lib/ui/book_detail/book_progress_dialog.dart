import 'package:dantex/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookProgressDialog extends ConsumerStatefulWidget {
  const BookProgressDialog({required this.book, super.key});

  final Book book;

  @override
  ConsumerState<BookProgressDialog> createState() => _BookProgressDialogState();
}

class _BookProgressDialogState extends ConsumerState<BookProgressDialog> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
