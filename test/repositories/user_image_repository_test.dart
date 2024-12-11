import 'dart:io';

import 'package:dantex/repositories/user_image_repository.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final storage = MockFirebaseStorage();
  final userImageStorageRef =
      storage.ref(UserImageRepository.imagesPath('userId'));
  group('Given a UserImageRepository', () {
    final userImageRepository =
        UserImageRepository(userImageStorageRef: userImageStorageRef);
    group('When uploadCustomUserImage is called', () {
      test('Then the image is uploaded and the download URL is returned',
          () async {
        final image = File('assets/images/google_logo.png');
        final downloadUrl =
            await userImageRepository.uploadCustomUserImage(image);

        expect(downloadUrl, isNotEmpty);
      });
    });
  });
}
