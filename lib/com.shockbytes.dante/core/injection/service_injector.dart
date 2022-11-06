import 'package:dantex/com.shockbytes.dante/data/bookdownload/api/book_api.dart';
import 'package:dantex/com.shockbytes.dante/data/bookdownload/book_downloader.dart';
import 'package:dantex/com.shockbytes.dante/data/bookdownload/default_book_downloader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../../firebase_options.dart';

class ServiceInjector {
  ServiceInjector._();

  static setup() async {
    await _setupBookDownloader();
    await _setupFirebaseAuth();
    await _setupFirebaseDatabase();
  }

  static Future _setupBookDownloader() async {
    await Get.putAsync<BookDownloader>(
      () async => DefaultBookDownloader(
        Get.find<BookApi>(),
      ),
      permanent: true,
    );
  }

  static Future _setupFirebaseAuth() async {
    await Get.putAsync<FirebaseAuth>(
      () async => FirebaseAuth.instance,
      permanent: true,
    );
  }

  static Future _setupFirebaseDatabase() async {
    await Get.putAsync<FirebaseDatabase>(
      () async => FirebaseDatabase.instanceFor(
        app: await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        databaseURL: 'https://dante-books.europe-west1.firebasedatabase.app/',
      ),
      permanent: true,
    );
  }
}
