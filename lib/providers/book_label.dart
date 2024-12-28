import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_label.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_label.g.dart';

@riverpod
List<Book> booksWithLabel(Ref ref, String labelId) {
  return ref.watch(allBooksProvider).when(
        data: (books) {
          return books
              .where((book) => book.labels.map((e) => e.id).contains(labelId))
              .toList();
        },
        error: (e, s) => [],
        loading: () => [],
      );
}

@Riverpod(keepAlive: true)
Stream<List<BookLabel>> allBookLabels(Ref ref) {
  return ref.watch(bookLabelRepositoryProvider).allLabels();
}
