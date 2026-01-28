import 'package:flutter/widgets.dart';

Widget buildLocalImage(String path, {BoxFit? fit, double? width, double? height}) {
  return Image.network(path, fit: fit, width: width, height: height);
}