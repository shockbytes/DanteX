import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {

  UrlLauncher._();

  static Future<void> launch(String url) async {
    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    }
  }
}
