import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_state.dart';

class BookRecommendation {
  final String recommendationId;
  final BookRecommender recommender;
  final RecommendedBook book;
  final String recommendation;

  BookRecommendation({
    required this.recommendationId,
    required this.recommender,
    required this.book,
    required this.recommendation,
  });


  Map<String, dynamic> toJson() {
    return {
      'suggestionId': recommendationId,
      'suggester': recommender.toJson(),
      'suggestion': book.toJson(),
      'recommendation': recommendation,
    };
  }

  static BookRecommendation fromJson(dynamic json) {
    return BookRecommendation(
      recommendationId: json['suggestionId'],
      recommender: BookRecommender.fromJson(json['suggester']),
      book: RecommendedBook.fromJson(json['suggestion']),
      recommendation: json['recommendation'],
    );
  }
}

class RecommendedBook {
  final String title;
  final String subTitle;
  final String author;
  final BookState state;
  final int pageCount;
  final String publishedDate;
  final String isbn;
  final String? thumbnailAddress;
  final String language;
  final String? summary;

  RecommendedBook({
    required this.title,
    required this.subTitle,
    required this.author,
    required this.state,
    required this.pageCount,
    required this.publishedDate,
    required this.isbn,
    required this.thumbnailAddress,
    required this.language,
    required this.summary,
  });

  static RecommendedBook fromBook(Book book) {
    return RecommendedBook(
      title: book.title,
      subTitle: book.subTitle,
      author: book.author,
      state: book.state,
      pageCount: book.pageCount,
      publishedDate: book.publishedDate,
      isbn: book.isbn,
      thumbnailAddress: book.thumbnailAddress,
      language: book.language,
      summary: book.summary,
    );
  }

  static RecommendedBook fromJson(dynamic json) {
    return RecommendedBook(
      title: json['title'],
      subTitle: json['subTitle'],
      author: json['author'],
      state: BookState.wishlist, // It will always be put on the wishlist.
      pageCount: json['pageCount'],
      publishedDate: json['publishedDate'],
      isbn: json['isbn'],
      thumbnailAddress: json['thumbnailAddress'],
      language: json['language'],
      summary: json['summary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subTitle': subTitle,
      'author': author,
      'state': state.name,
      'pageCount': pageCount,
      'publishedDate': publishedDate,
      'isbn': isbn,
      'thumbnailAddress': thumbnailAddress,
      'language': language,
      'summary': summary,
    };
  }
}

class BookRecommender {
  final String name;
  final String? picture;

  BookRecommender({
    required this.name,
    required this.picture,
  });

  static BookRecommender fromJson(dynamic json) {
    return BookRecommender(
      name: json['name'],
      picture: json['picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'picture': picture,
    };
  }
}

class RecommendationRequest {
  final String recommendation;
  final RecommendedBook recommendedBook;

  RecommendationRequest(
    this.recommendation,
    this.recommendedBook,
  );

  Map<String, dynamic> toJson() {
    return {
      // TODO
    };
  }
}
