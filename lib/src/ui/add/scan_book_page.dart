import 'package:dantex/src/providers/service.dart';
import 'package:dantex/src/ui/add/add_book_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScanBookPage extends ConsumerWidget {
  static const _invalidIsbn = '-1';

  const ScanBookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(scanIsbnProvider(context)).maybeWhen(
        data: (query) {
          // Query might be invalid if user aborts scan process.
          if (query == _invalidIsbn) {
            Navigator.pop(context);
          }

          return SafeArea(
            child: AddBookWidget.fullScreen(
              query: query,
            ),
          );
        },
        orElse: () {
          return Container();
        },
      ),
    );
  }
}
