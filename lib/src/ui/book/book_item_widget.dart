import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/ui/book/desktop_book_action_menu.dart';
import 'package:dantex/src/ui/book/mobile_book_action_menu.dart';
import 'package:dantex/src/util/extensions.dart';
import 'package:dantex/src/util/utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BookItemWidget extends StatelessWidget {
  final Book _book;

  final ExpandableController _controller = ExpandableController();
  final bool useMobileLayout;

  final Function(Book book, BookState updatedState) onBookStateChanged;
  final Function(Book book) onBookDeleted;

  BookItemWidget(
    this._book, {
    required this.useMobileLayout,
    required this.onBookStateChanged,
    required this.onBookDeleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go(
          DanteRoute.bookDetail.navigationUrl.replaceAll(':bookId', _book.id),
        );
      },
      child: _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: .2,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          _buildMainContentRow(context),
          const SizedBox(height: 8),
          _buildLabels(),
          _buildMobileBookActions(context),
        ],
      ),
    );
  }

  ExpandablePanel _buildMobileBookActions(BuildContext context) {
    return ExpandablePanel(
      collapsed: Container(),
      expanded: MobileBookActionMenu(
        _book,
        onBookDeleted: onBookDeleted,
        onBookStateChanged: onBookStateChanged,
      ),
      controller: _controller,
    );
  }

  Align _buildLabels() {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 4.0,
        children: _book.labels.map(_chipFromLabel).toList(),
      ),
    );
  }

  Row _buildMainContentRow(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: _book.thumbnailAddress!,
            width: 48,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _book.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _book.subTitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                _book.author,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            _buildOverflowButton(),
            if (_book.state == BookState.reading)
              _buildProgressCircle(
                context,
                currentPage: _book.currentPage,
                pageCount: _book.pageCount,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverflowButton() {
    if (useMobileLayout) {
      return IconButton(
        onPressed: () => _controller.toggle(),
        icon: const Icon(Icons.more_horiz),
      );
    } else {
      return DesktopBookActionMenu(
        _book,
        onBookDeleted: onBookDeleted,
        onBookStateChanged: onBookStateChanged,
      );
    }
  }

  Widget _chipFromLabel(BookLabel label) {
    final Color labelColor = label.hexColor.toColor();
    return FilterChip(
      label: Text(
        label.title,
        style: TextStyle(
          fontSize: 12,
          color: labelColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: labelColor)),
      onSelected: (bool value) {
        // TODO Open menu with all books with same label
      },
    );
  }

  Widget _buildProgressCircle(
    BuildContext context, {
    required int currentPage,
    required int pageCount,
  }) {
    final double percentage = computePercentage(currentPage, pageCount);

    return CircularPercentIndicator(
      radius: 20.0,
      lineWidth: 2.0,
      percent: percentage,
      center: Text(
        doublePercentageToString(percentage),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      progressColor: Theme.of(context).colorScheme.onSecondaryContainer,
    );
  }
}
