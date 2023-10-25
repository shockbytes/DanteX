import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';
import 'package:dantex/src/data/book/firebase_book_repository.dart';
import 'package:dantex/src/data/settings/settings_repository.dart';
import 'package:dantex/src/data/settings/shared_preferences_settings_repository.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

@riverpod
class BookRepository extends _$BookRepository {
  @override
  FirebaseBookRepository build() => FirebaseBookRepository(
        ref.watch(firebaseAuthProvider),
        ref.watch(firebaseDatabaseProvider),
      );

  Future<void> addToWishlist(Book book) {
    return _addBook(book, BookState.wishlist);
  }

  Future<void> addToForLater(Book book) {
    return _addBook(book, BookState.readLater);
  }

  Future<void> addToReading(Book book) {
    return _addBook(book, BookState.reading);
  }

  Future<void> addToRead(Book book) {
    return _addBook(book, BookState.read);
  }

  Future<void> _addBook(Book book, BookState bookState) {
    final Book updatedBook = book.copyWith(newState: bookState);
    return state.create(updatedBook);
  }
}

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) =>
    SharedPreferencesSettingsRepository(
      ref.watch(sharedPreferencesProvider),
    );

@riverpod
class IsRandomBooksEnabled extends _$IsRandomBooksEnabled {
  @override
  bool build() => ref.watch(settingsRepositoryProvider).isRandomBooksEnabled();

  void toggle() {
    ref
        .watch(settingsRepositoryProvider)
        .setIsRandomBooksEnabled(isRandomBooksEnabled: !state);
    state = !state;
  }
}

@riverpod
class IsTrackingEnabled extends _$IsTrackingEnabled {
  @override
  bool build() => ref.watch(settingsRepositoryProvider).isTrackingEnabled();

  void toggle() {
    ref
        .watch(settingsRepositoryProvider)
        .setIsTrackingEnabled(isTrackingEnabled: !state);
    state = !state;
  }
}
