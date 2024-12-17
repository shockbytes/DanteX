import 'package:dantex/models/book_recommendation.dart';
import 'package:dantex/providers/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommendations.g.dart';

// Mark this provider to stay alive when the app is running to act as a cache
// of the recommendations.
@Riverpod(keepAlive: true)
Future<List<BookRecommendation>> recommendations(Ref ref) async {
  final repository = ref.watch(recommendationsRepositoryProvider);
  return repository.loadRecommendations();
}
