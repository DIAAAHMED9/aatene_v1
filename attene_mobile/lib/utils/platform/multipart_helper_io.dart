import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<http.MultipartFile> multipartFromFile({
  required String field,
  required File file,
  String? filename,
  String? contentType,
}) async {
  return http.MultipartFile.fromPath(
    field,
    file.path,
    filename: filename ?? file.uri.pathSegments.last,
    contentType: (contentType == null) ? null : MediaType.parse(contentType),
  );
}
