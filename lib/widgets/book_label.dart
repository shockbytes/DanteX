import 'package:dantex/models/book_label.dart';
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
        side: BorderSide(color: label.color),
      ),
      child: Text(
        label.title,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: label.color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
