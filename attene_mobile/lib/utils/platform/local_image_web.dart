import 'package:flutter/widgets.dart';

/// Web: Image.file غير مدعوم بنفس الطريقة، لذلك نستخدم Image.network مع المسار (غالباً blob/url).
Widget buildLocalImage(String path, {BoxFit? fit, double? width, double? height}) {
  return Image.network(path, fit: fit, width: width, height: height);
}
