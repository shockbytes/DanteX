import 'package:dantex/models/book.dart';
import 'package:dantex/models/page_record.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/util/date_time.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPageRecordDialog extends ConsumerWidget {
  const EditPageRecordDialog({required this.bookId, super.key});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(bookProvider(bookId)).value;
    if (book == null) {
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: const Text('book_detail.page_record_details').tr(),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ...book.pageRecords.map(
              (pageRecord) => _PageRecordItem(
                key: ValueKey('${book.id}_page_record_${pageRecord.id}'),
                book: book,
                pageRecord: pageRecord,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageRecordItem extends StatelessWidget {
  const _PageRecordItem({
    required this.pageRecord,
    required this.book,
    super.key,
  });

  final PageRecord pageRecord;
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(pageRecord.timestamp.formatWithDayMonthYear()),
        Text('${pageRecord.fromPage} - ${pageRecord.toPage}'),
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: () async => showDialog(
            context: context,
            builder: (context) => _ConfirmDeleteDialog(
              book: book,
              pageRecordId: pageRecord.id,
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfirmDeleteDialog extends ConsumerWidget {
  const _ConfirmDeleteDialog({
    required this.book,
    required this.pageRecordId,
  });

  final Book book;
  final String pageRecordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('book_detail.delete_page_record').tr(),
      content: const Text('book_detail.delete_page_record_description').tr(),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('book_detail.cancel').tr(),
        ),
        OutlinedButton(
          onPressed: () async {
            await ref.read(bookRepositoryProvider).deletePageRecord(
                  book,
                  pageRecordId,
                );
            if (context.mounted) {
              Navigator.of(context).pop();
              if (book.pageRecords.length == 1) {
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('book_detail.delete').tr(),
        ),
      ],
    );
  }
}
