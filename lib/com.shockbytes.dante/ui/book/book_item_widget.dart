

import 'package:dantex/com.shockbytes.dante/data/book/entity/book.dart';
import 'package:flutter/material.dart';

class BookItemWidget extends StatelessWidget {

  final Book _book;

  BookItemWidget(this._book);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(_book.title)
        ],
      ),
    );
  }

}