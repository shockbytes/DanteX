import 'package:dantex/data/book/book.dart';
import 'package:dantex/data/book/book_state.dart';
import 'package:dantex/data/book/google_books_response.dart';
import 'package:dantex/providers/client.dart';
import 'package:dantex/providers/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book.g.dart';

@riverpod
Stream<List<Book>> booksForState(Ref ref, BookState bookState) {
  final bookDatabase = ref.watch(bookDatabaseProvider);

  if (bookDatabase == null) {
    return const Stream.empty();
  }
  return bookDatabase.onValue.map((event) {
    switch (event.type) {
      case DatabaseEventType.childAdded:
      case DatabaseEventType.childRemoved:
      case DatabaseEventType.childChanged:
      case DatabaseEventType.childMoved:
        // No need to handle these case.
        break;
      case DatabaseEventType.value:
        final data = event.snapshot.toMap();

        if (data == null) {
          return [];
        }

        final books = data.values
            .map(
              (value) {
                final bookMap =
                    (value as Map<dynamic, dynamic>).cast<String, dynamic>();
                return Book.fromJson(bookMap);
              },
            )
            .where((book) => book.state == bookState)
            .toList();

        return books;
    }
    return [];
  });
}

@Riverpod(keepAlive: true)
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

  return parsedResponse.items.map((e) => e.toBook()).nonNulls.toList();
}

extension DataSnapshotExtension on DataSnapshot {
  Map<String, dynamic>? toMap() {
    return (value != null) ? (value! as Map<dynamic, dynamic>).cast() : null;
  }
}
