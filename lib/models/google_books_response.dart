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
    required List<Items> items,
  }) = _GoogleBooksResponse;

  factory GoogleBooksResponse.fromJson(Map<String, dynamic> json) =>
      _$GoogleBooksResponseFromJson(json);
}

@freezed
class Items with _$Items {
  const factory Items({
    required String? kind,
    required String? id,
    required String? etag,
    required String? selfLink,
    required VolumeInfo? volumeInfo,
    required SaleInfo? saleInfo,
    required AccessInfo? accessInfo,
    required SearchInfo? searchInfo,
  }) = _Items;

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  const Items._();

  Book? toBook() {
    final volumeInfo = this.volumeInfo;

    return Book(
      id: '-1',
      title: volumeInfo?.title ?? '',
      subTitle: volumeInfo?.subtitle ?? '',
      author: volumeInfo?.authors?.join(', ') ?? '',
      state: BookState.readLater,
      pageCount: volumeInfo?.pageCount ?? 0,
      currentPage: 0,
      publishedDate: volumeInfo?.publishedDate ?? '',
      position: 0,
      isbn: volumeInfo?.industryIdentifiers
              ?.where((ii) => ii.type == 'ISBN_13')
              .map((e) => e.identifier)
              .join(', ') ??
          '',
      thumbnailAddress: volumeInfo?.imageLinks?.thumbnail,
      startDate: null,
      endDate: null,
      forLaterDate: null,
      language: volumeInfo?.language ?? 'NA',
      rating: 0,
      notes: '',
      summary: 'TODO Load Description',
      labels: [],
      googleBooksLink: volumeInfo?.infoLink,
    );
  }
}

@freezed
class SearchInfo with _$SearchInfo {
  const factory SearchInfo({
    required String? textSnippet,
  }) = _SearchInfo;

  factory SearchInfo.fromJson(Map<String, dynamic> json) =>
      _$SearchInfoFromJson(json);
}

@freezed
class AccessInfo with _$AccessInfo {
  const factory AccessInfo({
    required String? country,
    required String? viewability,
    required bool? embeddable,
    required bool? publicDomain,
    required String? textToSpeechPermission,
    required Epub? epub,
    required Pdf? pdf,
    required String? webReaderLink,
    required String? accessViewStatus,
    required bool? quoteSharingAllowed,
  }) = _AccessInfo;

  factory AccessInfo.fromJson(Map<String, dynamic> json) =>
      _$AccessInfoFromJson(json);
}

@freezed
class Pdf with _$Pdf {
  const factory Pdf({
    required bool? isAvailable,
  }) = _Pdf;

  factory Pdf.fromJson(Map<String, dynamic> json) => _$PdfFromJson(json);
}

@freezed
class Epub with _$Epub {
  const factory Epub({
    required bool? isAvailable,
  }) = _Epub;

  factory Epub.fromJson(Map<String, dynamic> json) => _$EpubFromJson(json);
}

@freezed
class SaleInfo with _$SaleInfo {
  const factory SaleInfo({
    required String? country,
    required String? saleability,
    required bool? isEbook,
  }) = _SaleInfo;

  factory SaleInfo.fromJson(Map<String, dynamic> json) =>
      _$SaleInfoFromJson(json);
}

@freezed
class VolumeInfo with _$VolumeInfo {
  const factory VolumeInfo({
    required String? title,
    required String? subtitle,
    required List<String>? authors,
    required String? publishedDate,
    required List<IndustryIdentifiers>? industryIdentifiers,
    required ReadingModes? readingModes,
    required int? pageCount,
    required String? printType,
    required double? averageRating,
    required int? ratingsCount,
    required String? maturityRating,
    required bool? allowAnonLogging,
    required String? contentVersion,
    required ImageLinks? imageLinks,
    required String? language,
    required String? previewLink,
    required String? infoLink,
    required String? canonicalVolumeLink,
  }) = _VolumeInfo;

  factory VolumeInfo.fromJson(Map<String, dynamic> json) =>
      _$VolumeInfoFromJson(json);
}

@freezed
class IndustryIdentifiers with _$IndustryIdentifiers {
  const factory IndustryIdentifiers({
    required String? type,
    required String? identifier,
  }) = _IndustryIdentifiers;

  factory IndustryIdentifiers.fromJson(Map<String, dynamic> json) =>
      _$IndustryIdentifiersFromJson(json);
}

@freezed
class ReadingModes with _$ReadingModes {
  const factory ReadingModes({
    required bool? text,
    required bool? image,
  }) = _ReadingModes;

  factory ReadingModes.fromJson(Map<String, dynamic> json) =>
      _$ReadingModesFromJson(json);
}

@freezed
class ImageLinks with _$ImageLinks {
  const factory ImageLinks({
    required String? smallThumbnail,
    required String? thumbnail,
  }) = _ImageLinks;

  factory ImageLinks.fromJson(Map<String, dynamic> json) =>
      _$ImageLinksFromJson(json);
}
