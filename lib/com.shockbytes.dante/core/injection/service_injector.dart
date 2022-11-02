import 'package:dantex/com.shockbytes.dante/data/bookdownload/api/book_api.dart';
import 'package:dantex/com.shockbytes.dante/data/bookdownload/book_downloader.dart';
import 'package:dantex/com.shockbytes.dante/data/bookdownload/default_book_downloader.dart';
import 'package:get/get.dart';

class ServiceInjector {
  ServiceInjector._();

  static setup() async {
    await _setupBookDownloader();
  }

  static Future _setupBookDownloader() async {
    await Get.putAsync<BookDownloader>(
      () async => DefaultBookDownloader(
        Get.find<BookApi>(),
      ),
      permanent: true,
    );
  }

  static _setupAppSettings() async {
//     await Get.putAsync<AppSettings>(() {
//       return SharedPreferences.getInstance().then((sp) => SharedPreferencesAppSettings(sp));
//     });
  }
}
