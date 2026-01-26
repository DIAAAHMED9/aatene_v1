import 'package:dio/dio.dart';

/// Web/unsupported platforms: local file paths are not accessible.
/// Return null so callers can skip attaching files.
Future<MultipartFile?> dioMultipartFromLocalPath(String path) async {
  return null;
}
