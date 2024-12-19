import 'package:dantex/models/book.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/ui/shared/book_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RateBookDialog extends ConsumerStatefulWidget {
  const RateBookDialog({required this.book, super.key});

  final Book book;

  @override
  ConsumerState<RateBookDialog> createState() => _RateBookDialogState();
}

class _RateBookDialogState extends ConsumerState<RateBookDialog> {
  late double rating;

  @override
  void initState() {
    super.initState();
    if (widget.book.rating > 0) {
      rating = widget.book.rating.toDouble();
    } else {
      rating = 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('book_detail.rate_title').tr(args: [widget.book.title]),
          const SizedBox(height: 16),
          BookImage(widget.book.thumbnailAddress, size: 96),
          const SizedBox(height: 16),
          RatingBar.builder(
            minRating: 1,
            initialRating: rating,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Theme.of(context).colorScheme.primary,
            ),
            onRatingUpdate: (rating) {
              setState(() => this.rating = rating);
            },
          ),
          const SizedBox(height: 16),
          _RatingLabel(rating),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () async {
            await ref.read(bookRepositoryProvider).setRating(
                  widget.book.id,
                  rating.toInt(),
                );
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('book_detail.rate').tr(),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}

class _RatingLabel extends StatelessWidget {
  const _RatingLabel(this.rating);

  final double rating;

  @override
  Widget build(BuildContext context) {
    String label;
    if (rating <= 1) {
      label = 'book_detail.rating_terrible';
    } else if (rating <= 2) {
      label = 'book_detail.rating_bad';
    } else if (rating <= 3) {
      label = 'book_detail.rating_ok';
    } else if (rating <= 4) {
      label = 'book_detail.rating_good';
    } else {
      label = 'book_detail.rating_great';
    }
    return Text(label).tr();
  }
}
