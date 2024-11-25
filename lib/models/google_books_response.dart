import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_books_response.freezed.dart';
part 'google_books_response.g.dart';

@freezed
class GoogleBooksResponse with _$GoogleBooksResponse {
  const factory GoogleBooksResponse({
    required String? kind,
    required int totalItems,
    required List<GoogleBooksItem>? items,
  }) = _GoogleBooksResponse;

  factory GoogleBooksResponse.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksResponseFromJson(json);
}

@freezed
class GoogleBooksItem with _$GoogleBooksItem {
  const factory GoogleBooksItem({
    required String kind,
    required String id,
    required String etag,
    required String selfLink,
    required GoogleBooksVolumeInfo volumeInfo,
    required GoogleBooksSaleInfo saleInfo,
    required GoogleBooksAccessInfo accessInfo,
    required GoogleBooksSearchInfo searchInfo,
  }) = _GoogleBooksItem;

  factory GoogleBooksItem.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksItemFromJson(json);

  const GoogleBooksItem._();

  Book? toBook() {
    final volumeInfo = this.volumeInfo;

    return Book(
      id: '-1',
      title: volumeInfo.title ?? '',
      subTitle: volumeInfo.subtitle ?? '',
      author: volumeInfo.authors?.join(', ') ?? '',
      state: BookState.readLater,
      pageCount: volumeInfo.pageCount ?? 0,
      currentPage: 0,
      publishedDate: volumeInfo.publishedDate ?? '',
      position: 0,
      isbn: volumeInfo.industryIdentifiers
              ?.where((ii) => ii.type == 'ISBN_13')
              .map((e) => e.identifier)
              .join(', ') ??
          '',
      thumbnailAddress: volumeInfo.imageLinks?.thumbnail,
      startDate: null,
      endDate: null,
      forLaterDate: null,
      language: volumeInfo.language ?? 'NA',
      rating: 0,
      notes: '',
      summary: 'TODO Load Description',
      labels: [],
    );
  }
}

@freezed
class GoogleBooksSearchInfo with _$GoogleBooksSearchInfo {
  const factory GoogleBooksSearchInfo({
    required String textSnippet,
  }) = _GoogleBooksSearchInfo;

  factory GoogleBooksSearchInfo.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksSearchInfoFromJson(json);
}

@freezed
class GoogleBooksAccessInfo with _$GoogleBooksAccessInfo {
  const factory GoogleBooksAccessInfo({
    required String country,
    required String viewability,
    required bool embeddable,
    required bool publicDomain,
    required String textToSpeechPermission,
    required GoogleBooksEpub epub,
    required GoogleBooksPdf pdf,
    required String webReaderLink,
    required String accessViewStatus,
    required bool quoteSharingAllowed,
  }) = _GoogleBooksAccessInfo;

  factory GoogleBooksAccessInfo.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksAccessInfoFromJson(json);
}

@freezed
class GoogleBooksEpub with _$GoogleBooksEpub {
  const factory GoogleBooksEpub({
    required bool isAvailable,
  }) = _GoogleBooksEpub;

  factory GoogleBooksEpub.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksEpubFromJson(json);
}

@freezed
class GoogleBooksPdf with _$GoogleBooksPdf {
  const factory GoogleBooksPdf({
    required bool isAvailable,
  }) = _GoogleBooksPdf;

  factory GoogleBooksPdf.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksPdfFromJson(json);
}

@freezed
class GoogleBooksSaleInfo with _$GoogleBooksSaleInfo {
  const factory GoogleBooksSaleInfo({
    required String country,
    required String saleability,
    required bool isEbook,
  }) = _GoogleBooksSaleInfo;

  factory GoogleBooksSaleInfo.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksSaleInfoFromJson(json);
}

@freezed
class GoogleBooksVolumeInfo with _$GoogleBooksVolumeInfo {
  const factory GoogleBooksVolumeInfo({
    required String? title,
    required String? subtitle,
    required List<String>? authors,
    required String? publishedDate,
    required List<GoogleBooksIndustryIdentifier>? industryIdentifiers,
    required GoogleBooksReadingModes? readingModes,
    required int? pageCount,
    required String? printType,
    required int? averageRating,
    required int? ratingsCount,
    required String? maturityRating,
    required bool? allowAnonLogging,
    required String? contentVersion,
    required GoogleBooksImageLinks? imageLinks,
    required String? language,
    required String? previewLink,
    required String? infoLink,
    required String? canonicalVolumeLink,
  }) = _GoogleBooksVolumeInfo;

  factory GoogleBooksVolumeInfo.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksVolumeInfoFromJson(json);
}

@freezed
class GoogleBooksImageLinks with _$GoogleBooksImageLinks {
  const factory GoogleBooksImageLinks({
    required String smallThumbnail,
    required String thumbnail,
  }) = _GoogleBooksImageLinks;

  factory GoogleBooksImageLinks.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksImageLinksFromJson(json);
}

@freezed
class GoogleBooksReadingModes with _$GoogleBooksReadingModes {
  const factory GoogleBooksReadingModes({
    required bool text,
    required bool image,
  }) = _GoogleBooksReadingModes;

  factory GoogleBooksReadingModes.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksReadingModesFromJson(json);
}

@freezed
class GoogleBooksIndustryIdentifier with _$GoogleBooksIndustryIdentifier {
  const factory GoogleBooksIndustryIdentifier({
    required String type,
    required String identifier,
  }) = _GoogleBooksIndustryIdentifier;

  factory GoogleBooksIndustryIdentifier.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksIndustryIdentifierFromJson(json);
}
