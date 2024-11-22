import 'package:dantex/data/book/book.dart';
import 'package:dantex/data/book/book_state.dart';
import 'package:dantex/data/book/google_books_response.dart';
import 'package:dantex/data/repo/book_repository.dart';
import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/client.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book.g.dart';

@riverpod
DatabaseReference? bookDatabase(Ref ref) {
  final database = ref.watch(firebaseDatabaseProvider);

  if (database == null) {
    return null;
  }

  // Only watch authStateChanges here so that the database reference is only
  // recreated when the user signs in or out.
  final userId = ref.watch(authStateChangesProvider).value?.uid;
  if (userId == null) {
    return null;
  }

  return database.ref(BookRepository.booksPath(userId));
}

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
    ref.watch(bookRepositoryProvider).booksForState(bookState).map(
          (books) => books
            ..sort(
              (a, b) => a.position.compareTo(b.position),
            ),
        );

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

@Riverpod(keepAlive: true)
class BackupInProgressNotifier extends _$BackupInProgressNotifier {
  @override
  bool build() => false;

  void start() => state = true;

  void done() => state = false;
}
