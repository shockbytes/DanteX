import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/models/google_books_response.dart';
import 'package:dantex/providers/client.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/providers/settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book.g.dart';

@riverpod
Stream<List<Book>> allBooks(Ref ref) =>
    ref.watch(bookRepositoryProvider).allBooks();

@riverpod
Stream<List<Book>> booksForState(Ref ref, BookState bookState) {
  final booksForState =
      ref.watch(bookRepositoryProvider).booksForState(bookState);

  final sortStrategy = ref.watch(bookSortStrategySettingProvider);

  return booksForState.map(
    (books) => books..sort(sortStrategy.comparator()),
  );
}

@riverpod
Future<List<Book>> searchRemoteBooks(
  Ref ref,
  String searchTerm,
) async {
  final googleBooksClient = ref.watch(googleBooksClientProvider);
  final response = await googleBooksClient.get<Map<String, dynamic>>(
    '/volumes',
    queryParameters: <String, dynamic>{
      'q': searchTerm,
    },
  );

  final data = response.data;
  if (data == null) {
    return [];
  }

  final parsedResponse = GoogleBooksResponse.fromJson(data);

  final items = parsedResponse.items;

  return items.map((e) => e.toBook()).nonNulls.toList();
}

@riverpod
Future<String> scanIsbn(Ref ref) async {
  try {
    final scanResult = await FlutterBarcodeScanner.scanBarcode(
      '#00000000', // Transparent line
      'add_book.cancel_scan'.tr(),
      false,
      ScanMode.BARCODE,
    );
    return scanResult;
  } on Exception catch (e, s) {
    ref
        .read(loggerProvider)
        .e('Failed to scan Barcode', error: e, stackTrace: s);
    return '-1';
  }
}

@Riverpod(keepAlive: true)
class BackupInProgressNotifier extends _$BackupInProgressNotifier {
  @override
  bool build() => false;

  void start() => state = true;
  void done() => state = false;
}

@riverpod
Stream<Book?> book(Ref ref, String bookId) =>
    ref.watch(bookRepositoryProvider).getBook(bookId);

@riverpod
class SearchTerm extends _$SearchTerm {
  @override
  String build() => '';

  // ignore: use_setters_to_change_properties
  void set(String term) => state = term;
  void clear() => state = '';
}
