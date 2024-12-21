import 'package:dantex/providers/repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPageRecordDialog extends ConsumerWidget {
  const ResetPageRecordDialog({required this.bookId, super.key});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          const Text('book_detail.delete_page_records').tr(),
        ],
      ),
      content: const Text('book_detail.delete_page_records_description').tr(),
      actions: [
        OutlinedButton(
          onPressed: () async => Navigator.of(context).pop(),
          child: const Text('book_detail.cancel').tr(),
        ),
        OutlinedButton(
          onPressed: () async {
            await ref.read(bookRepositoryProvider).resetPageRecords(bookId);
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
