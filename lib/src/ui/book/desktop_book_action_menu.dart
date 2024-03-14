import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/ui/book/book_action.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DesktopBookActionMenu extends StatelessWidget {
  final Book _book;

  final Function(Book book, BookState updatedState) onBookStateChanged;
  final Function(Book book) onBookDeleted;

  const DesktopBookActionMenu(
    this._book, {
    required this.onBookStateChanged,
    required this.onBookDeleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BookAction>(
      padding: const EdgeInsets.all(0),
      icon: const Icon(
        Icons.more_horiz,
      ),
      onSelected: (BookAction action) => _handleAction(context, action),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<BookAction>>[
        if (_book.state != BookState.readLater)
          PopupMenuItem(
            value: BookAction.moveToReadLater,
            child: _DesktopMenuActionItem(
              text: 'book-actions.move-to-later'.tr(),
              iconData: Icons.bookmark_outline,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        if (_book.state != BookState.reading)
          PopupMenuItem(
            value: BookAction.moveToReading,
            child: _DesktopMenuActionItem(
              text: 'book-actions.move-to-reading'.tr(),
              iconData: Icons.bookmark_outline,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        if (_book.state != BookState.read)
          PopupMenuItem(
            value: BookAction.moveToRead,
            child: _DesktopMenuActionItem(
              text: 'book-actions.move-to-read'.tr(),
              iconData: Icons.check,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        PopupMenuItem(
          value: BookAction.recommend,
          child: _DesktopMenuActionItem(
            text: 'book-actions.suggest'.tr(),
            iconData: Icons.whatshot_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        PopupMenuItem(
          value: BookAction.edit,
          child: _DesktopMenuActionItem(
            text: 'book-actions.edit'.tr(),
            iconData: Icons.edit_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        PopupMenuItem(
          value: BookAction.delete,
          child: _DesktopMenuActionItem(
            text: 'book-actions.delete'.tr(),
            iconData: Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }

  void _handleAction(BuildContext context, BookAction value) {
    switch (value) {
      case BookAction.moveToReadLater:
        onBookStateChanged(_book, BookState.readLater);
        break;
      case BookAction.moveToReading:
        onBookStateChanged(_book, BookState.reading);
        break;
      case BookAction.moveToRead:
        onBookStateChanged(_book, BookState.read);
        break;
      case BookAction.share:
        // Do not provide Share action for desktop UI.
        break;
      case BookAction.recommend:
        // _showSuggestBookDialog();
        break;
      case BookAction.edit:
        // TODO: Handle this case.
        break;
      case BookAction.delete:
        onBookDeleted(_book);
        break;
    }
  }
}

class _DesktopMenuActionItem extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color color;

  const _DesktopMenuActionItem({
    required this.text,
    required this.iconData,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
          ),
        ),
      ],
    );
  }
}
