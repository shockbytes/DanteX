import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dantex/src/data/book/book_repository.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/recommendations/book_recommendation.dart';
import 'package:dantex/src/data/recommendations/recommendations_repository.dart';
import 'package:rxdart/rxdart.dart';

class Recommendations {
  final RecommendationsRepository _recommendationsRepository;
  final BookRepository _bookRepository;

  final PublishSubject<RecommendationEvent> _eventsSubject = PublishSubject();

  Stream<RecommendationEvent> get events => _eventsSubject.stream;

  final BehaviorSubject<List<BookRecommendation>> _recommendedBooksSubject =
      BehaviorSubject();

  Stream<List<BookRecommendation>> get recommendedBooks =>
      _recommendedBooksSubject.stream;

  Recommendations(this._recommendationsRepository, this._bookRepository) {
    _poke();
  }

  DateTime newRecommendationsAvailableAt() =>
      _recommendationsRepository.dateForNewRecommendations();

  void _poke() {
    unawaited(
      _loadRecommendedBooks().then(_recommendedBooksSubject.add),
    );
  }

  Future<List<BookRecommendation>> _loadRecommendedBooks() async {
    final List<BookRecommendation> recommendations =
        await _recommendationsRepository.loadRecommendations();
    final List<String> reportedRecommendations =
        await _recommendationsRepository.getReportedRecommendations();

    return recommendations
        .whereNot(
          (element) =>
              reportedRecommendations.contains(element.recommendationId),
        )
        .toList();
  }

  Future<void> reportRecommendation(BookRecommendation recommendation) {
    return _recommendationsRepository
        .reportRecommendation(recommendation.recommendationId)
        .then((value) => _poke())
        .then(
          (value) => _addEvent(
            ReportRecommendationEvent(recommendation.book.title),
          ),
        );
  }

  void _addEvent(RecommendationEvent event) {
    _eventsSubject.add(event);
  }

  Future<void> recommendBook(Book book, String recommendation) {
    return _recommendationsRepository.recommendBook(book, recommendation);
  }

  Future<void> addToWishlist(BookRecommendation recommendation) {
    return _bookRepository.addToWishlist(_toBook(recommendation.book)).then(
          (value) => _addEvent(
            MoveToWishlistEvent(
              recommendation.book.title,
            ),
          ),
        );
  }

  Book _toBook(RecommendedBook recommendedBook) {
    return Book(
      id: '',
      title: recommendedBook.title,
      subTitle: recommendedBook.subTitle,
      author: recommendedBook.author,
      state: recommendedBook.state,
      pageCount: recommendedBook.pageCount,
      currentPage: 0,
      publishedDate: recommendedBook.publishedDate,
      position: 0,
      isbn: recommendedBook.isbn,
      thumbnailAddress: recommendedBook.thumbnailAddress,
      startDate: null,
      endDate: null,
      forLaterDate: null,
      language: recommendedBook.language,
      rating: 0,
      notes: null,
      summary: recommendedBook.summary,
    );
  }
}

sealed class RecommendationEvent {}

class MoveToWishlistEvent extends RecommendationEvent {
  final String title;

  MoveToWishlistEvent(this.title);
}

class ReportRecommendationEvent extends RecommendationEvent {
  final String title;

  ReportRecommendationEvent(this.title);
}
