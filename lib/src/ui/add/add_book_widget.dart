import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/src/bloc/add/add_book_bloc.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:dantex/src/providers/bloc.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/ui/core/handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

class AddBookWidget extends ConsumerStatefulWidget {
  final String _query;
  final AddBookWidgetAppearance appearance;

  const AddBookWidget(
    this._query, {
    Key? key,
    required this.appearance,
  }) : super(key: key);

  const AddBookWidget.fullScreen({
    required String query,
    super.key,
  })  : _query = query,
        appearance = AddBookWidgetAppearance.fullScreen;

  @override
  createState() => _AddBookSheetState();
}

class _AddBookSheetState extends ConsumerState<AddBookWidget> {
  final double _bottomSheetHeight = 440.0;
  late AddBookBloc _bloc;

  StreamSubscription<Book>? _onBookAddedStream;

  @override
  void initState() {
    super.initState();
    _bloc = ref.read(addBookBlocProvider);

    _onBookAddedStream = _bloc.onBookAdded.listen(
      (event) {
        // Just pop the screen here, no need to handle something else
        Navigator.of(context).pop();
      },
    );
  }

  @override
  void dispose() {
    _onBookAddedStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.appearance == AddBookWidgetAppearance.bottomSheet) const Handle(),
        FutureBuilder<BookSuggestion>(
          future: _bloc.downloadBook(widget._query),
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = _buildBookWidget(
                context,
                snapshot.data!,
                widget.appearance,
              );
            } else if (snapshot.hasError) {
              child = GenericErrorWidget(snapshot.error);
            } else {
              child = _buildLoadingWidget();
            }

            return switch (widget.appearance) {
              AddBookWidgetAppearance.bottomSheet => SizedBox(
                  height: _bottomSheetHeight,
                  child: child,
                ),
              AddBookWidgetAppearance.fullScreen => Expanded(child: child),
            };
          },
        ),
      ],
    );
  }

  Widget _buildBookWidget(
    BuildContext context,
    BookSuggestion bookSuggestion,
    AddBookWidgetAppearance appearance,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (appearance == AddBookWidgetAppearance.fullScreen) const SizedBox(height: 16),
        _buildImage(bookSuggestion.target, appearance),
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
                    onPressed: () => _bloc.addToForLater(bookSuggestion.target),
                    child: Text(
                      AppLocalizations.of(context)!.tab_for_later,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _bloc.addToReading(bookSuggestion.target),
                    child: Text(
                      AppLocalizations.of(context)!.tab_reading,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _bloc.addToRead(bookSuggestion.target),
                    child: Text(
                      AppLocalizations.of(context)!.tab_read,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 16),
            DanteComponents.outlinedButton(
              onPressed: () => _bloc.addToWishlist(bookSuggestion.target),
              child: Text(
                AppLocalizations.of(context)!.tab_wishlist,
              ),
            ),
          ],
        ),
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.not_my_book,
          ),
          onPressed: () {
            // TODO Show bookSuggestion.suggestions in another ticket
          },
        ),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget _buildImage(Book target, AddBookWidgetAppearance appearance) {
    if (target.thumbnailAddress != null) {
      return CachedNetworkImage(
        imageUrl: target.thumbnailAddress!,
        height: appearance.imageSize,
      );
    } else {
      return Icon(
        Icons.image,
        size: appearance.imageSize,
      );
    }
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
