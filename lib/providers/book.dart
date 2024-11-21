import 'package:dantex/data/book/book.dart';
import 'package:dantex/data/book/book_state.dart';
import 'package:dantex/data/book/google_books_response.dart';
import 'package:dantex/data/repo/book_repository.dart';
import 'package:dantex/providers/client.dart';
import 'package:dantex/providers/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book.g.dart';

@riverpod
BookRepository bookRepository(Ref ref) {
  final bookDatabase = ref.watch(bookDatabaseProvider);

  if (bookDatabase == null) {
    throw Exception('Database reference is null');
  }

  return BookRepository(bookDatabase: bookDatabase);
}

@riverpod
Stream<List<Book>> booksForState(Ref ref, BookState bookState) =>
    ref.watch(bookRepositoryProvider).booksForState(bookState);

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
  if (items == null) {
    return [];
  }

  return items.map((e) => e.toBook()).nonNulls.toList();
}
