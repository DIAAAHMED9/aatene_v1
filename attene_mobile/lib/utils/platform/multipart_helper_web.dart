import 'package:http/http.dart' as http;
import 'dart:typed_data';

/// Web: نبني MultipartFile من bytes
Future<http.MultipartFile> multipartFromBytes({
  required String field,
  required Uint8List bytes,
  required String filename,
  String? contentType,
}) async {
  return http.MultipartFile.fromBytes(field, bytes, filename: filename);
}
