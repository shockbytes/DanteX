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
        ref.read(firebaseAuthProvider),
        ref.read(firebaseDatabaseProvider),
      );

  Future<void> addToWishlist(Book book) {
    return _addBook(book, BookState.WISHLIST);
  }

  Future<void> addToForLater(Book book) {
    return _addBook(book, BookState.READ_LATER);
  }

  Future<void> addToReading(Book book) {
    return _addBook(book, BookState.READING);
  }

  Future<void> addToRead(Book book) {
    return _addBook(book, BookState.READ);
  }

  Future<void> _addBook(Book book, BookState bookState) {
    final Book updatedBook = book.copyWith(newState: bookState);
    return state.create(updatedBook);
  }
}

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) =>
    SharedPreferencesSettingsRepository(
      ref.read(sharedPreferencesProvider),
    );

@riverpod
class IsRandomBooksEnabled extends _$IsRandomBooksEnabled {
  @override
  bool build() => ref.read(settingsRepositoryProvider).isRandomBooksEnabled();

  void toggle() {
    ref.read(settingsRepositoryProvider).setIsRandomBooksEnabled(!state);
    state = !state;
  }
}

@riverpod
class IsTrackingEnabled extends _$IsTrackingEnabled {
  @override
  bool build() => ref.read(settingsRepositoryProvider).isTrackingEnabled();

  void toggle() {
    ref.read(settingsRepositoryProvider).setIsTrackingEnabled(!state);
    state = !state;
  }
}
