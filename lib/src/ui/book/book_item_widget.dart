import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/util/dante_colors.dart';
import 'package:dantex/src/util/extensions.dart';
import 'package:dantex/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BookItemWidget extends StatelessWidget {
  final Book _book;

  const BookItemWidget(this._book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: DanteColors.textSecondary,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: DanteColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _book.subTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: DanteColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _book.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: DanteColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO Show overflow menu
                    },
                    icon: const Icon(Icons.more_horiz),
                  ),
                  if (_book.state == BookState.READING)
                    _buildProgressCircle(_book.currentPage, _book.pageCount)
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 4.0,
              children: _book.labels.map(_chipFromLabel).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipFromLabel(BookLabel label) {
    Color labelColor = HexColor.fromHex(label.hexColor);
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

  Widget _buildProgressCircle(int currentPage, int pageCount) {
    double percentage = computePercentage(currentPage, pageCount);

    return CircularPercentIndicator(
      radius: 20.0,
      lineWidth: 2.0,
      percent: percentage,
      center: Text(
        doublePercentageToString(percentage),
        style: const TextStyle(color: DanteColors.textPrimary, fontSize: 11),
      ),
      backgroundColor: DanteColors.backgroundSearch,
      progressColor: DanteColors.accent,
    );
  }
}
