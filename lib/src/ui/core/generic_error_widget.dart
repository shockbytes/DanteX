import 'package:flutter/widgets.dart';

class GenericErrorWidget extends StatelessWidget {
  final Object? _error;

  const GenericErrorWidget(this._error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          _error?.toString() ?? 'Unknown error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
