import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/screens/edit_book_screen.dart';
import 'package:dantex/theme/dante_colors.dart';
import 'package:dantex/widgets/suggestions/suggest_book_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class BookActionsBottomSheet extends ConsumerWidget {
  const BookActionsBottomSheet({required this.book, super.key});

  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final danteColors = Theme.of(context).extension<DanteColors>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            if (book.state != BookState.readLater) ...[
              _BookActionRow(
                key: const Key('move_to_read_later'),
                icon: Icon(
                  Icons.bookmark_outline,
                  color: danteColors?.forLaterColor,
                ),
                label: 'book_action.move_to_read_later'.tr(),
                onTap: () async {
                  Navigator.of(context).pop();
                  await ref
                      .read(bookRepositoryProvider)
                      .moveBookToState(book.id, BookState.readLater);
                },
              ),
              const SizedBox(height: 16),
            ],
            if (book.state != BookState.reading) ...[
              _BookActionRow(
                key: const Key('move_to_reading'),
                icon: Icon(
                  Icons.book_outlined,
                  color: danteColors?.readingColor,
                ),
                label: 'book_action.move_to_reading'.tr(),
                onTap: () async {
                  Navigator.of(context).pop();
                  await ref
                      .read(bookRepositoryProvider)
                      .moveBookToState(book.id, BookState.reading);
                },
              ),
              const SizedBox(height: 16),
            ],
            if (book.state != BookState.read) ...[
              _BookActionRow(
                key: const Key('move_to_read'),
                icon: Icon(
                  Icons.done_outline,
                  color: danteColors?.readColor,
                ),
                label: 'book_action.move_to_read'.tr(),
                onTap: () async {
                  Navigator.of(context).pop();
                  await ref
                      .read(bookRepositoryProvider)
                      .moveBookToState(book.id, BookState.read);
                },
              ),
              const SizedBox(height: 16),
            ],
            _BookActionRow(
              icon: Icon(
                Icons.share_outlined,
                color: danteColors?.shareColor,
              ),
              label: 'book_action.share'.tr(),
              onTap: () async {
                Navigator.of(context).pop();
                await Share.share(
                  'book_action.share_message'
                      .tr(args: [book.title, book.googleBooksLink ?? '']),
                );
              },
            ),
            const SizedBox(height: 16),
            _BookActionRow(
              icon: Icon(
                Icons.local_fire_department_outlined,
                color: danteColors?.suggestColor,
              ),
              label: 'book_action.suggest'.tr(),
              onTap: () async {
                Navigator.of(context).pop();
                await showModalBottomSheet<void>(
                  showDragHandle: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => SuggestBookBottomSheet(book: book),
                );
              },
            ),
            const SizedBox(height: 16),
            _BookActionRow(
              icon: Icon(
                Icons.edit_outlined,
                color: danteColors?.editColor,
              ),
              label: 'book_action.edit'.tr(),
              onTap: () async {
                Navigator.of(context).pop();
                await context.push(
                  EditBookScreen.routeLocation.replaceAll(
                    ':bookId',
                    book.id,
                  ),
                );
              },
            ),
            const Divider(),
            _BookActionRow(
              key: const Key('book_action_delete'),
              icon: Icon(
                Icons.delete_outline,
                color: danteColors?.deleteColor,
              ),
              label: 'book_action.delete'.tr(),
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(bookRepositoryProvider).delete(book.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BookActionRow extends StatelessWidget {
  const _BookActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final Icon icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Text(label),
          ],
        ),
      ),
    );
  }
}
