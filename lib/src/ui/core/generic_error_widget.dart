import 'package:flutter/widgets.dart';

class GenericErrorWidget extends StatelessWidget {
  final Object? _error;

  const GenericErrorWidget(this._error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _error?.toString() ?? 'Unknown error',
      ),
    );
  }
}
