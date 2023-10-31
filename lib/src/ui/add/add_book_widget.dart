import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:dantex/src/ui/book/book_image.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/dante_loading_indicator.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/ui/core/handle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AddBookWidgetAppearance {
  bottomSheet(
    imageSize: 96,
  ),
  fullScreen(
    imageSize: 128,
  );

  final double imageSize;

  const AddBookWidgetAppearance({
    required this.imageSize,
  });
}

class AddBookWidget extends ConsumerWidget {
  final String _query;
  final AddBookWidgetAppearance appearance;

  const AddBookWidget(
    this._query, {
    required this.appearance,
    Key? key,
  }) : super(key: key);

  const AddBookWidget.fullScreen({
    required String query,
    super.key,
  })  : _query = query,
        appearance = AddBookWidgetAppearance.fullScreen;

  final double _bottomSheetHeight = 440.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(downloadBookProvider(_query));
    Widget child = const DanteLoadingIndicator();
    book.when(
      data: (data) {
        child = BookWidget(
          bookSuggestion: data,
          appearance: appearance,
        );
      },
      error: (error, stackTrace) {
        child = GenericErrorWidget(error);
      },
      loading: () {
        child = const DanteLoadingIndicator();
      },
    );

    return Column(
      children: [
        if (appearance == AddBookWidgetAppearance.bottomSheet) const Handle(),
        switch (appearance) {
          AddBookWidgetAppearance.bottomSheet => SizedBox(
              height: _bottomSheetHeight,
              child: child,
            ),
          AddBookWidgetAppearance.fullScreen => Expanded(child: child),
        },
      ],
    );
  }
}

openAddBookSheet(
  BuildContext context, {
  required String query,
}) async {
  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    barrierColor: Colors.black54,
    builder: (context) => AddBookWidget(
      query,
      appearance: AddBookWidgetAppearance.bottomSheet,
    ),
  );
}

class BookWidget extends ConsumerWidget {
  final BookSuggestion bookSuggestion;
  final AddBookWidgetAppearance appearance;

  const BookWidget({
    required this.bookSuggestion,
    required this.appearance,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (appearance == AddBookWidgetAppearance.fullScreen)
          const SizedBox(height: 16),
        BookImage(
          bookSuggestion.target.thumbnailAddress,
          size: appearance.imageSize,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                bookSuggestion.target.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Text(
              bookSuggestion.target.author,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () async {
                      await ref
                          .read(bookRepositoryProvider)
                          .addToForLater(bookSuggestion.target);
                      // Just pop the screen here, no need to handle something else
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('tabs.for_later'.tr()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () async {
                      await ref
                          .read(bookRepositoryProvider)
                          .addToReading(bookSuggestion.target);
                      // Just pop the screen here, no need to handle something else
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('tabs.reading'.tr()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () async {
                      await ref
                          .read(bookRepositoryProvider)
                          .addToRead(bookSuggestion.target);
                      // Just pop the screen here, no need to handle something else
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('tabs.read'.tr()),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 16),
            DanteComponents.outlinedButton(
              onPressed: () async {
                await ref
                    .read(bookRepositoryProvider)
                    .addToWishlist(bookSuggestion.target);
                // Just pop the screen here, no need to handle something else
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text('tabs.wishlist'.tr()),
            ),
          ],
        ),
        TextButton(
          child: Text('not_my_book'.tr()),
          onPressed: () {
            // TODO Show bookSuggestion.suggestions in another ticket
          },
        ),
      ],
    );
  }
}
