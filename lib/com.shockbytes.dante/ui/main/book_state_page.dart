import 'package:dantex/com.shockbytes.dante/data/book/entity/book_state.dart';
import 'package:flutter/widgets.dart';

class BookStatePage extends StatelessWidget {

  final BookState _state;

  BookStatePage(this._state);

  Widget build(BuildContext context) {
    return Container(
      child: Text(_state.name),
    );
  }
}
