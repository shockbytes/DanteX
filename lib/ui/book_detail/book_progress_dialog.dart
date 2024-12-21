import 'package:dantex/models/book.dart';
import 'package:dantex/providers/repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookProgressDialog extends ConsumerStatefulWidget {
  const BookProgressDialog({
    required this.book,
    required this.onPagesUpdated,
    super.key,
  });

  final Book book;
  final void Function(int currentPage) onPagesUpdated;

  @override
  ConsumerState<BookProgressDialog> createState() => _BookProgressDialogState();
}

class _BookProgressDialogState extends ConsumerState<BookProgressDialog> {
  late TextEditingController _currentPageController;
  late TextEditingController _pageCountController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentPageController =
        TextEditingController(text: widget.book.currentPage.toString());
    _pageCountController =
        TextEditingController(text: widget.book.pageCount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('book_detail.enter_pages').tr(),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: _currentPageController,
              decoration: InputDecoration(
                labelText: 'book_detail.current_page'.tr(),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                final currentPage = int.tryParse(value);
                final maxPages = int.tryParse(_pageCountController.text);
                if (maxPages == null || currentPage == null) {
                  return null;
                }
                if (currentPage > maxPages) {
                  return 'book_detail.current_page_error'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text('/', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: _pageCountController,
              decoration: InputDecoration(
                labelText: 'book_detail.pages'.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              final currentPage = int.tryParse(_currentPageController.text);
              final pageCount = int.tryParse(_pageCountController.text);

              if (pageCount == null || currentPage == null) {
                return;
              }

              await ref.read(bookRepositoryProvider).setPageDetails(
                    widget.book,
                    currentPage,
                    pageCount,
                  );

              widget.onPagesUpdated(currentPage);

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('book_detail.save').tr(),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
