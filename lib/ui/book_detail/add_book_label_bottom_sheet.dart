import 'package:dantex/models/book.dart';
import 'package:dantex/providers/book_label.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/ui/book_detail/create_label_dialog.dart';
import 'package:dantex/ui/shared/dante_loading_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBookLabelBottomSheet extends ConsumerWidget {
  const AddBookLabelBottomSheet({required this.book, super.key});

  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBookLabels = ref.watch(allBookLabelsProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'book_detail.add_label',
            style: Theme.of(context).textTheme.headlineMedium,
          ).tr(),
          const SizedBox(height: 32),
          allBookLabels.when(
            data: (allLabels) {
              final availableLabels = allLabels.where(
                (label) => !book.labels.contains(label),
              );
              return ExpandableCarousel(
                options: ExpandableCarouselOptions(
                  enlargeCenterPage: true,
                  viewportFraction: 0.4,
                  enlargeFactor: 0.5,
                  showIndicator: false,
                ),
                items: availableLabels
                    .map(
                      (label) => Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () async {
                                await ref
                                    .read(bookRepositoryProvider)
                                    .addBookLabel(book, label);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sell,
                                    size: 80,
                                    color: label.color,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    label.title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async => showDialog(
                              context: context,
                              builder: (context) => _ConfirmDeleteLabelDialog(
                                labelId: label.id,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              );
            },
            error: (e, s) => const SizedBox.shrink(),
            loading: () => const DanteLoadingIndicator(),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async => showDialog(
              context: context,
              builder: (context) => const CreateLabelDialog(),
            ),
            icon: const Icon(Icons.add),
            label: const Text('book_detail.create_label').tr(),
          ),
        ],
      ),
    );
  }
}

class _ConfirmDeleteLabelDialog extends ConsumerWidget {
  const _ConfirmDeleteLabelDialog({required this.labelId});

  final String labelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('book_detail.delete_label').tr(),
      content: const Text('book_detail.delete_label_description').tr(),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('book_detail.cancel').tr(),
        ),
        TextButton(
          onPressed: () async {
            await ref.read(bookLabelRepositoryProvider).deleteLabel(labelId);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('book_detail.delete').tr(),
        ),
      ],
    );
  }
}
