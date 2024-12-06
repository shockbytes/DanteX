import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class BookImageRepository {
  BookImageRepository({required Reference bookImageStorageRef})
      : _bookImageStorageRef = bookImageStorageRef;

  final Reference _bookImageStorageRef;

  static String imagesPath(String uid) => '/custom_images/$uid';

  Future<String> uploadCustomBookImage(File image) async {
    final imageRef = _bookImageStorageRef.child(image.uri.pathSegments.last);
    await imageRef.putFile(image);
    final downloadUrl = await imageRef.getDownloadURL();

    return downloadUrl;
  }
}
