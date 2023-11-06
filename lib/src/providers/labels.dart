import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'labels.g.dart';

@riverpod
Stream<List<BookLabel>> getBookLabels(GetBookLabelsRef ref) =>
    ref.watch(bookLabelRepositoryProvider).getBookLabels();
