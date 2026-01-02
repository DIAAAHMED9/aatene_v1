import 'package:url_launcher/url_launcher.dart';



class UrlHelper {
  static Future<void> open(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}