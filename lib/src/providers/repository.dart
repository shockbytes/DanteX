import 'package:dantex/src/data/book/book_label_repository.dart';
import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/firebase_book_label_repository.dart';
import 'package:dantex/src/data/book/firebase_book_repository.dart';
import 'package:dantex/src/data/recommendations/default_recommendations_repository.dart';
import 'package:dantex/src/data/recommendations/recommendations_repository.dart';
import 'package:dantex/src/data/book/firebase_page_record_repository.dart';
import 'package:dantex/src/data/book/page_record_repository.dart';
import 'package:dantex/src/data/settings/settings_repository.dart';
import 'package:dantex/src/data/settings/shared_preferences_settings_repository.dart';
import 'package:dantex/src/providers/api.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:dantex/src/providers/cache.dart';
import 'package:dantex/src/providers/service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

@riverpod
BookRepository bookRepository(BookRepositoryRef ref) => FirebaseBookRepository(
      ref.watch(firebaseAuthProvider),
      ref.watch(firebaseDatabaseProvider),
    );

@riverpod
RecommendationsRepository recommendationsRepository(RecommendationsRepositoryRef ref) => DefaultRecommendationsRepository(
      ref.watch(recommendationsApiProvider),
      ref.watch(recommendationsCacheProvider),
      ref.watch(recommendationsReportCacheProvider),
    );

@riverpod
BookLabelRepository bookLabelRepository(BookLabelRepositoryRef ref) =>
    FirebaseBookLabelRepository(
      ref.watch(firebaseAuthProvider),
      ref.watch(firebaseDatabaseProvider),
    );

@riverpod
PageRecordRepository pageRecordRepository(
  PageRecordRepositoryRef ref,
) =>
    FirebasePageRecordRepository(
      ref.watch(firebaseAuthProvider),
      ref.watch(firebaseDatabaseProvider),
    );

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
