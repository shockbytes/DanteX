import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/src/bloc/add/add_book_bloc.dart';
import 'package:dantex/src/core/injection/dependency_injector.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/ui/core/handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddBookSheet extends StatefulWidget {
  final String _query;

  const AddBookSheet(
    this._query, {
    Key? key,
  }) : super(key: key);

  @override
  createState() => _AddBookSheetState();
}

class _AddBookSheetState extends State<AddBookSheet> {
  final AddBookBloc _bloc = DependencyInjector.get<AddBookBloc>();

  final double _height = 400.0;

  StreamSubscription<Book>? _onBookAddedStream;

  @override
  void initState() {
    super.initState();
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
        const Handle(),
        FutureBuilder<BookSuggestion>(
          future: _bloc.downloadBook(widget._query),
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = _buildBookWidget(context, snapshot.data!);
            } else if (snapshot.hasError) {
              child = GenericErrorWidget(snapshot.error);
            } else {
              child = _buildLoadingWidget();
            }

            return SizedBox(
              height: _height,
              child: child,
            );
          },
        ),
      ],
    );
  }

  Widget _buildBookWidget(BuildContext context, BookSuggestion bookSuggestion) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildImage(bookSuggestion.target),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            bookSuggestion.target.title,
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          bookSuggestion.target.author,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DanteComponents.outlinedButton(
              onPressed: () => _bloc.addToWishlist(bookSuggestion.target),
              child: Text(
                AppLocalizations.of(context)!.tab_wishlist,
              ),
            ),
            DanteComponents.outlinedButton(
              onPressed: () => _bloc.addToForLater(bookSuggestion.target),
              child: Text(
                AppLocalizations.of(context)!.tab_for_later,
              ),
            ),
            DanteComponents.outlinedButton(
              onPressed: () => _bloc.addToReading(bookSuggestion.target),
              child: Text(
                AppLocalizations.of(context)!.tab_reading,
              ),
            ),
            DanteComponents.outlinedButton(
              onPressed: () => _bloc.addToRead(bookSuggestion.target),
              child: Text(
                AppLocalizations.of(context)!.tab_read,
              ),
            ),
          ],
        ),
        MaterialButton(
          padding: const EdgeInsets.all(16.0),
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

  Widget _buildImage(Book target) {
    if (target.thumbnailAddress != null) {
      return CachedNetworkImage(
        imageUrl: target.thumbnailAddress!,
        height: 128,
      );
    } else {
      return const Icon(
        Icons.image,
        size: 128,
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
    builder: (context) => AddBookSheet(query),
  );
}
