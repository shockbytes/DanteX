import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BookProgress extends ConsumerStatefulWidget {
  final Book book;

  const BookProgress({required this.book, super.key});

  @override
  createState() => _BookProgressState();
}

class _BookProgressState extends ConsumerState<BookProgress> {
  final _currentPageController = TextEditingController();
  final _pageCountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentPageController.text = widget.book.currentPage.toString();
    _pageCountController.text = widget.book.pageCount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => _showEditPageDialog(context),
      child: SizedBox(
        height: 140,
        child: CircularPercentIndicator(
          key: const ValueKey('book-detail-progress-indicator'),
          radius: 70.0,
          lineWidth: 2.0,
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          widgetIndicator: Icon(
            Icons.circle,
            size: 12,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          percent: widget.book.pageCount > 0
              ? widget.book.currentPage / widget.book.pageCount
              : 0.0,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_outlined,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.book.currentPage} / ${widget.book.pageCount}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          progressColor: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  Future<void> _showEditPageDialog(BuildContext context) async {
    return showDanteDialog(
      context,
      title: 'book_progress.enter_pages'.tr(),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      content: Material(
        child: Column(
          children: [
            DanteTextField(
              controller: _currentPageController,
              label: Text('book_progress.current_page'.tr()),
            ),
            const Text(
              '/',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            DanteTextField(
              controller: _pageCountController,
              label: Text('book_progress.page_count'.tr()),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
      actions: [
        DanteDialogAction(
          name: 'book_progress.save'.tr(),
          action: (BuildContext context) async {
            final newCurrentPage =
                int.tryParse(_currentPageController.text) ?? 0;
            final newPageCount = int.tryParse(_pageCountController.text) ?? 0;

            if (newCurrentPage > newPageCount) {
              await showPlatformDialog(
                context: context,
                builder: (_) => PlatformAlertDialog(
                  title: Text('book_progress.error'.tr()),
                  content: Text(
                    'book_progress.error_current_page'.tr(),
                  ),
                  actions: [
                    PlatformDialogAction(
                      child: Text('ok'.tr()),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
              return;
            }
            if (context.mounted) {
              Navigator.of(context).pop();
            }
            await ref.read(bookRepositoryProvider).updatePageInfo(
                  bookId: widget.book.id,
                  currentPage: newCurrentPage,
                  pageCount: newPageCount,
                );
          },
        ),
      ],
    );
  }
}
