import 'package:dantex/src/data/bookdownload/api/book_api.dart';
import 'package:dantex/src/data/bookdownload/api/google_books_api.dart';
import 'package:dantex/src/data/recommendations/api/firebase_recommendations_api.dart';
import 'package:dantex/src/data/recommendations/api/recommendations_api.dart';
import 'package:dantex/src/providers/authentication.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api.g.dart';

@riverpod
BookApi booksApi(BooksApiRef ref) => GoogleBooksApi();

@riverpod
RecommendationsApi recommendationsApi(RecommendationsApiRef ref) =>
    FirebaseRecommendationsApi(
      ref.watch(firebaseAuthProvider),
    );
