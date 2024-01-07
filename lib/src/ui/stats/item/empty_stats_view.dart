import 'package:flutter/material.dart';

class EmptyStatsView extends StatelessWidget {
  final String _text;

  const EmptyStatsView(
    this._text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _text,
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
