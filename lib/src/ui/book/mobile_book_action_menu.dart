import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MobileBookActionMenu extends StatelessWidget {
  final Book _book;

  final Function(Book book, BookState updatedState) onBookStateChanged;
  final Function(Book book) onBookDeleted;

  const MobileBookActionMenu(
    this._book, {
    required this.onBookStateChanged,
    required this.onBookDeleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DanteDivider(),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          children: [
            if (_book.state != BookState.readLater)
              _buildBookAction(
                title: 'book-actions.move-to-later'.tr(),
                icon: Icons.bookmark_outline,
                color: Theme.of(context).colorScheme.secondary,
                onClick: () => onBookStateChanged(_book, BookState.readLater),
              ),
            if (_book.state != BookState.reading)
              _buildBookAction(
                title: 'book-actions.move-to-reading'.tr(),
                icon: Icons.bookmark_outline,
                color: Theme.of(context).colorScheme.secondary,
                onClick: () => onBookStateChanged(_book, BookState.reading),
              ),
            if (_book.state != BookState.read)
              _buildBookAction(
                title: 'book-actions.move-to-read'.tr(),
                icon: Icons.check,
                color: Theme.of(context).colorScheme.secondary,
                onClick: () => onBookStateChanged(_book, BookState.read),
              ),
            _buildBookAction(
              title: 'book-actions.share'.tr(),
              icon: Icons.share_outlined,
              color: Theme.of(context).colorScheme.secondary,
              onClick: () {
                // TODO Share book in ticket: TODO
              },
            ),
            _buildBookAction(
              title: 'book-actions.suggest'.tr(),
              icon: Icons.whatshot_outlined,
              color: Theme.of(context).colorScheme.secondary,
              onClick: () {
                // TODO Suggest book in ticket: TODO
              },
            ),
            _buildBookAction(
              title: 'book-actions.edit'.tr(),
              icon: Icons.edit_outlined,
              color: Theme.of(context).colorScheme.secondary,
              onClick: () {
                // TODO Edit book in ticket: TODO
              },
            ),
            _buildBookAction(
              title: 'book-actions.delete'.tr(),
              icon: Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
              onClick: () => onBookDeleted(_book),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBookAction({
    required String title,
    required IconData icon,
    required VoidCallback onClick,
    required Color color,
  }) {
    return InkWell(
      onTap: onClick,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
