import 'package:dantex/models/book_label.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/widgets/shared/book_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookLabelButton extends StatelessWidget {
  const BookLabelButton({
    required this.label,
    super.key,
  });

  final BookLabel label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      key: ValueKey('book_label_${label.id}_button'),
      onPressed: () async => showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) => _BookLabelBottomSheet(
          key: ValueKey('book_label_${label.id}_bottom_sheet'),
          label: label,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        side: BorderSide(color: label.color),
      ),
      child: Text(
        label.title,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: label.color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _BookLabelBottomSheet extends ConsumerWidget {
  const _BookLabelBottomSheet({required this.label, super.key});

  final BookLabel label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(allBooksProvider).value;
    final booksWithLabel = books?.where((book) => book.labels.contains(label));

    if (booksWithLabel == null) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.biggest.height * 0.8;

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        label.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: label.color),
                      ),
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(top: 8)),
                  SliverToBoxAdapter(
                    child: Center(
                      child: const Text('book_label.books_with_label').plural(
                        booksWithLabel.length,
                        args: [booksWithLabel.length.toString()],
                      ),
                    ),
                  ),
                  const SliverPadding(padding: EdgeInsets.only(top: 8)),
                  SliverList.separated(
                    itemCount: booksWithLabel.length,
                    itemBuilder: (context, index) {
                      final book = booksWithLabel.elementAt(index);
                      return InkWell(
                        child: Row(
                          children: [
                            BookImage(book.thumbnailAddress, size: 32),
                            const SizedBox(width: 32),
                            Text(
                              book.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
