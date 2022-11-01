import 'package:dantex/com.shockbytes.dante/data/book/entity/book.dart';
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
          color: Colors.black26,
          width: .5,
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
