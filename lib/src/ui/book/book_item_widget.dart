import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/providers/app_router.dart';
import 'package:dantex/src/util/extensions.dart';
import 'package:dantex/src/util/utils.dart';
import 'package:easy_localization/easy_localization.dart';
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
          Row(
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
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _book.author,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () => _controller.toggle(),
                    icon: const Icon(Icons.more_horiz),
                  ),
                  if (_book.state == BookState.reading)
                    _buildProgressCircle(
                      context,
                      currentPage: _book.currentPage,
                      pageCount: _book.pageCount,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: 4.0,
              children: _book.labels.map(_chipFromLabel).toList(),
            ),
          ),
          ExpandablePanel(
            collapsed: Container(),
            expanded: _buildBookActions(context),
            controller: _controller,
          ),
        ],
      ),
    );
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

  Widget _buildBookActions(BuildContext context) {
    return GridView(
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
