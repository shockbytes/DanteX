import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/ui/book_detail/book_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class BookProgressWidget extends ConsumerStatefulWidget {
  const BookProgressWidget({required this.book, super.key});

  final Book book;

  @override
  ConsumerState<BookProgressWidget> createState() => _BookProgressWidgetState();
}

class _BookProgressWidgetState extends ConsumerState<BookProgressWidget> {
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.book.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final isReading = widget.book.state == BookState.reading;
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        customColors: CustomSliderColors(
          progressBarColor: Theme.of(context).colorScheme.primary,
          trackColor: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      initialValue: currentPage.toDouble(),
      max: widget.book.pageCount.toDouble(),
      innerWidget: (value) {
        return GestureDetector(
          onTap: () async => showDialog(
            context: context,
            builder: (context) => BookProgressDialog(
              book: widget.book,
              onPagesUpdated: (currentPage) =>
                  setState(() => this.currentPage = currentPage),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(height: 8),
              if (isReading)
                Text(
                  '${value.round()} / ${widget.book.pageCount}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
            ],
          ),
        );
      },
      onChange: (value) => setState(() => currentPage = value.round()),
      onChangeEnd: (value) async {
        await ref.read(bookRepositoryProvider).setCurrentPage(
              widget.book,
              currentPage,
            );
      },
    );
  }
}
