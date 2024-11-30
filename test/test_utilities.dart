import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dantex/models/backup_data.dart';
import 'package:dantex/models/book.dart';
import 'package:dantex/models/book_state.dart';
import 'package:dantex/models/google_books_response.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<FirebaseDatabase> getMockDatabase() async {
  final mockDataString =
      await File('assets/data/test-repository.json').readAsString();
  final mockData = json.decode(mockDataString);

  final mockDatabase = MockFirebaseDatabase.instance;
  await mockDatabase.ref().set(mockData);

  return mockDatabase;
}

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}

Book getMockBook({String? id, String? isbn, int? position}) => Book(
      id: id ?? 'id',
      title: 'title',
      subTitle: 'subTitle',
      author: 'author',
      state: BookState.reading,
      pageCount: 10,
      currentPage: 1,
      publishedDate: DateTime.now().toIso8601String(),
      position: position ?? 1,
      isbn: isbn ?? 'isbn',
      thumbnailAddress: 'thumbnailAddress',
      startDate: null,
      endDate: null,
      forLaterDate: null,
      language: 'language',
      rating: 5,
      notes: 'notes',
      summary: 'summary',
    );

BackupData getMockBackupData({DateTime? timeStamp}) => BackupData(
      id: 'id',
      device: 'device',
      fileName: 'fileName',
      bookCount: 10,
      timeStamp: timeStamp ?? DateTime.now(),
      isLegacyBackup: true,
    );

GoogleBooksResponse getMockGoogleBookResponse({List<Items>? items}) {
  return GoogleBooksResponse(
    kind: 'kind',
    totalItems: 3,
    items: items ??
        [
          const Items(
            kind: 'kind',
            id: 'id',
            etag: 'etag',
            selfLink: 'selfLink',
            volumeInfo: VolumeInfo(
              title: 'title',
              subtitle: 'subtitle',
              authors: ['author'],
              publishedDate: 'publishedDate',
              industryIdentifiers: [
                IndustryIdentifiers(
                  type: 'type',
                  identifier: 'identifier',
                ),
              ],
              readingModes: ReadingModes(
                text: true,
                image: false,
              ),
              pageCount: 10,
              printType: 'printType',
              averageRating: 5,
              ratingsCount: 1,
              maturityRating: 'maturityRating',
              allowAnonLogging: true,
              contentVersion: 'contentVersion',
              imageLinks: ImageLinks(
                smallThumbnail: 'smallThumbnail',
                thumbnail: 'thumbnail',
              ),
              language: 'language',
              previewLink: 'previewLink',
              infoLink: 'infoLink',
              canonicalVolumeLink: 'canonicalVolumeLink',
            ),
            saleInfo: SaleInfo(
              country: 'country',
              saleability: 'saleability',
              isEbook: true,
            ),
            accessInfo: AccessInfo(
              country: 'country',
              viewability: 'viewability',
              embeddable: true,
              publicDomain: true,
              textToSpeechPermission: 'textToSpeechPermission',
              epub: Epub(
                isAvailable: true,
              ),
              pdf: Pdf(
                isAvailable: true,
              ),
              webReaderLink: 'webReaderLink',
              accessViewStatus: 'accessViewStatus',
              quoteSharingAllowed: true,
            ),
            searchInfo: SearchInfo(
              textSnippet: 'textSnippet',
            ),
          ),
        ],
  );
}

({Stream<Uint8List> stream, int length}) getLegacyBookStream() {
  // Convert the legacy book JSON into a stream of bytes.
  final legacyBookBytes = utf8.encode(legacyBookJson);
  return (
    stream: Stream.fromIterable([legacyBookBytes]),
    length: legacyBookBytes.length
  );
}

const legacyBookJson = '''
{
  "backupMetadata": {
    "books": 91,
    "device": "Nokia XR20",
    "fileName": "google-drive_man_1732274092306_91_Nokia XR20.json",
    "id": "google-drive_man_1732274092306_91_Nokia XR20.json",
    "storageProvider": "google-drive",
    "timestamp": 1732274092306
  },
  "books": [
    {
      "author": "Jules Verne",
      "currentPage": 0,
      "endDate": 0,
      "googleBooksLink": "http://books.google.com.au/books?id=mfrLsgEACAAJ&dq=twenty%2Btwo%2Bthousand%2Bleagues&hl=&source=gbs_api",
      "id": 267,
      "isbn": "9781512093599",
      "labels": [],
      "language": "en",
      "pageCount": 212,
      "position": 7,
      "publishedDate": "2015-05-08",
      "rating": 0,
      "startDate": 0,
      "state": "READ_LATER",
      "subTitle": "",
      "summary": "Twenty Thousand Leagues Under the Sea is a classic science fiction novel by French writer Jules Verne published in 1870. It tells the story of Captain Nemo and his submarine Nautilus, as seen from the perspective of Professor Pierre Aronnax after he, his servant Conseil, and Canadian whaler Ned Land wash up on their ship. On the Nautilus, the three embark on a journey which has them going all around the world, under the sea.",
      "thumbnailAddress": "http://books.google.com/books/content?id=mfrLsgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
      "title": "Twenty Thousand Leagues Under the Sea",
      "wishlistDate": 1675574439493
    }
  ]
}
''';
