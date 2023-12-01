import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/ui/core/lottie_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget {
  final BookState _state;

  const EmptyStateView(
    this._state, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LottieView(
        lottieAsset: 'assets/lottie/books-staple.json',
        text: _textForState(_state),
      ),
    );
  }

  String _textForState(BookState state) {
    return switch (state) {
      BookState.readLater => 'empty-states.read-later'.tr(),
      BookState.reading => 'empty-states.reading'.tr(),
      BookState.read => 'empty-states.read'.tr(),
      BookState.wishlist => 'empty-states.wishlist'.tr(),
    };
  }
}
