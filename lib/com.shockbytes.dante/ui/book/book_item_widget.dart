import 'package:dantex/com.shockbytes.dante/data/book/entity/book.dart';
import 'package:dantex/com.shockbytes.dante/util/dante_colors.dart';
import 'package:flutter/material.dart';

class BookItemWidget extends StatelessWidget {
  final Book _book;

  BookItemWidget(this._book);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: DanteColors.textSecondary,
          width: .4,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          Text(_book.title),
          Text(_book.state.name),
        ],
      ),
    );
  }
}
