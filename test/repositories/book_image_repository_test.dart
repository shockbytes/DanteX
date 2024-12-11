import 'dart:io';

import 'package:dantex/repositories/book_image_repository.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final storage = MockFirebaseStorage();
  final bookImageStorageRef =
      storage.ref(BookImageRepository.imagesPath('userId'));
  group('Given a BookImageRepository', () {
    final bookImageRepository =
        BookImageRepository(bookImageStorageRef: bookImageStorageRef);
    group('When uploadCustomBookImage is called', () {
      test('Then the image is uploaded and the download URL is returned',
          () async {
        final image = File('assets/images/google_logo.png');
        final downloadUrl =
            await bookImageRepository.uploadCustomBookImage(image);

        expect(downloadUrl, isNotEmpty);
      });
    });
  });
}
