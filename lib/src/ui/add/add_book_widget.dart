import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/bookdownload/entity/book_suggestion.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:dantex/src/ui/book/book_image.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/dante_loading_indicator.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
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
    super.key,
  });

  const AddBookWidget.fullScreen({
    required String query,
    super.key,
  })  : _query = query,
        appearance = AddBookWidgetAppearance.fullScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(downloadBookProvider(_query));
    Widget child = const DanteLoadingIndicator();
    book.when(
      data: (data) {
        child = _BookSuggestionWidget(
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

    switch (appearance) {
      case AddBookWidgetAppearance.bottomSheet:
        return child;
      case AddBookWidgetAppearance.fullScreen:
        return Expanded(child: child);
    }
  }
}

openAddBookSheet(
  BuildContext context, {
  required String query,
}) async {
  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    barrierColor: Colors.black54,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AddBookWidget(
            query,
            appearance: AddBookWidgetAppearance.bottomSheet,
          ),
        ],
      ),
    ),
  );
}

enum BookSuggestionView {
  first,
  other,
}

class _BookSuggestionWidget extends ConsumerStatefulWidget {
  final BookSuggestion bookSuggestion;
  final AddBookWidgetAppearance appearance;

  const _BookSuggestionWidget({
    required this.bookSuggestion,
    required this.appearance,
    super.key,
  });

  @override
  createState() => _BookSuggestionWidgetState();
}

class _BookSuggestionWidgetState extends ConsumerState<_BookSuggestionWidget> {
  BookSuggestionView currentView = BookSuggestionView.first;
  late Book currentBook;
  late List<Book> otherBooks;

  @override
  void initState() {
    super.initState();
    currentBook = widget.bookSuggestion.target;
    otherBooks = widget.bookSuggestion.suggestions;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: SingleChildScrollView(
          child: switch (currentView) {
            BookSuggestionView.first => _FirstBookSuggestion(
                bookSuggestion: currentBook,
                appearance: widget.appearance,
                notMyBookCallback: () {
                  setState(() {
                    currentView = BookSuggestionView.other;
                  });
                },
              ),
            BookSuggestionView.other => _OtherBookSuggestions(
                otherSuggestions: widget.bookSuggestion.suggestions,
                selectOtherBookCallback: (book) {
                  setState(() {
                    otherBooks.insert(0, currentBook);
                    otherBooks.remove(book);
                    currentBook = book;
                    currentView = BookSuggestionView.first;
                  });
                },
                appearance: widget.appearance,
                backButtonCallback: () {
                  setState(() {
                    currentView = BookSuggestionView.first;
                  });
                },
              ),
          },
        ),
      ),
    );
  }
}

class _FirstBookSuggestion extends ConsumerWidget {
  final Book bookSuggestion;
  final AddBookWidgetAppearance appearance;
  final void Function() notMyBookCallback;

  const _FirstBookSuggestion({
    required this.bookSuggestion,
    required this.appearance,
    required this.notMyBookCallback,
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
          bookSuggestion.thumbnailAddress,
          size: appearance.imageSize,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                bookSuggestion.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Text(
              bookSuggestion.author,
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
                          .addToForLater(bookSuggestion);
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
                          .addToReading(bookSuggestion);
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
                          .addToRead(bookSuggestion);
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
            DanteOutlinedButton(
              onPressed: () async {
                await ref
                    .read(bookRepositoryProvider)
                    .addToWishlist(bookSuggestion);
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
          onPressed: notMyBookCallback,
          child: Text('not_my_book'.tr()),
        ),
      ],
    );
  }
}

class _OtherBookSuggestions extends ConsumerWidget {
  final List<Book> otherSuggestions;
  final AddBookWidgetAppearance appearance;

  final void Function() backButtonCallback;
  final void Function(Book) selectOtherBookCallback;

  const _OtherBookSuggestions({
    required this.otherSuggestions,
    required this.appearance,
    required this.backButtonCallback,
    required this.selectOtherBookCallback,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mq = MediaQuery.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: mq.size.height - mq.viewInsets.bottom - 225,
      ),
      child: Column(
        children: [
          Text(
            'recommendations.other_suggestions'.tr(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: otherSuggestions.length,
              itemBuilder: (context, index) {
                final book = otherSuggestions[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  leading: BookImage(
                    book.thumbnailAddress,
                    size: appearance.imageSize,
                  ),
                  onTap: () => selectOtherBookCallback(book),
                );
              },
            ),
          ),
          const Divider(),
          OutlinedButton(
            onPressed: backButtonCallback,
            child: Text('recommendations.nope'.tr()),
          ),
        ],
      ),
    );
  }
}
