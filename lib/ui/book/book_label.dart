import 'package:dantex/data/book/book_label.dart';
import 'package:flutter/material.dart';

class BookLabelButton extends StatelessWidget {
  const BookLabelButton({
    required this.label,
    super.key,
  });

  final BookLabel label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(label.title),
    );
  }
}
