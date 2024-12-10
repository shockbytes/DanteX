import 'package:dantex/models/book_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoBooksFound extends StatelessWidget {
  const NoBooksFound({
    required this.bookState,
    super.key,
  });

  final BookState bookState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset('assets/lottie/books-staple.json'),
          Text(
            _textForState,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String get _textForState {
    return switch (bookState) {
      BookState.readLater => 'book_list.empty_states.read-later'.tr(),
      BookState.reading => 'book_list.empty_states.reading'.tr(),
      BookState.read => 'book_list.empty_states.read'.tr(),
      BookState.wishlist => 'book_list.empty_states.wishlist'.tr(),
    };
  }
}
