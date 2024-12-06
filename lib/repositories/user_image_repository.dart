import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UserImageRepository {
  UserImageRepository({required Reference userImageStorageRef})
      : _userImageStorageRef = userImageStorageRef;

  final Reference _userImageStorageRef;

  static String imagesPath(String uid) => '/user_images/$uid';

  Future<String> uploadCustomUserImage(File image) async {
    final imageRef = _userImageStorageRef.child(image.uri.pathSegments.last);
    await imageRef.putFile(image);
    final downloadUrl = await imageRef.getDownloadURL();

    return downloadUrl;
  }
}
