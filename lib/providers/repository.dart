import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/client.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/repositories/book_image_repository.dart';
import 'package:dantex/repositories/book_label_repository.dart';
import 'package:dantex/repositories/book_repository.dart';
import 'package:dantex/repositories/realm_book_repository.dart';
import 'package:dantex/repositories/recommendations_repository.dart';
import 'package:dantex/repositories/user_image_repository.dart';
import 'package:dantex/repositories/user_settings_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

@riverpod
DatabaseReference? bookDatabaseRef(Ref ref) {
  final database = ref.watch(firebaseDatabaseProvider);

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
  final bookDatabase = ref.watch(bookDatabaseRefProvider);

  if (bookDatabase == null) {
    throw Exception('Database reference is null');
  }

  return BookRepository(bookDatabase: bookDatabase);
}

@riverpod
Reference? bookImageStorageRef(Ref ref) {
  final storage = ref.watch(firebaseStorageProvider);

  // Only watch authStateChanges here so that the database reference is only
  // recreated when the user signs in or out.
  final userId = ref.watch(authStateChangesProvider).value?.uid;
  if (userId == null) {
    return null;
  }

  return storage.ref(BookImageRepository.imagesPath(userId));
}

@riverpod
BookImageRepository bookImageRepository(Ref ref) {
  final bookImageStorageRef = ref.watch(bookImageStorageRefProvider);

  if (bookImageStorageRef == null) {
    throw Exception('Book image storage reference is null');
  }

  return BookImageRepository(bookImageStorageRef: bookImageStorageRef);
}

@riverpod
Reference? userImageStorageRef(Ref ref) {
  final storage = ref.watch(firebaseStorageProvider);

  // Only watch authStateChanges here so that the database reference is only
  // recreated when the user signs in or out.
  final userId = ref.watch(authStateChangesProvider).value?.uid;
  if (userId == null) {
    return null;
  }

  return storage.ref(UserImageRepository.imagesPath(userId));
}

@riverpod
UserImageRepository userImageRepository(Ref ref) {
  final userImageStorageRef = ref.watch(userImageStorageRefProvider);

  if (userImageStorageRef == null) {
    throw Exception('User image storage reference is null');
  }

  return UserImageRepository(userImageStorageRef: userImageStorageRef);
}

@riverpod
RecommendationsRepository recommendationsRepository(Ref ref) {
  final user = ref.watch(userProvider).value;
  final client = ref.watch(recommendationsClientProvider);

  return RecommendationsRepository(authToken: user?.authToken, client: client);
}

@riverpod
UserSettingsRepository userSettingsRepository(Ref ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);

  return UserSettingsRepository(sharedPreferences: sharedPreferences);
}

@riverpod
DatabaseReference? bookLabelDatabaseRef(Ref ref) {
  final database = ref.watch(firebaseDatabaseProvider);

  // Only watch authStateChanges here so that the database reference is only
  // recreated when the user signs in or out.
  final userId = ref.watch(authStateChangesProvider).value?.uid;
  if (userId == null) {
    return null;
  }

  return database.ref(BookLabelRepository.labelsPath(userId));
}

@riverpod
BookLabelRepository bookLabelRepository(Ref ref) {
  final bookLabelDatabase = ref.watch(bookLabelDatabaseRefProvider);

  if (bookLabelDatabase == null) {
    throw Exception('Database reference is null');
  }

  return BookLabelRepository(bookLabelDatabase: bookLabelDatabase);
}

@riverpod
RealmBookRepository realmBookRepository(Ref ref) {
  final realm = ref.watch(realmProvider);

  return RealmBookRepository(realm: realm);
}
