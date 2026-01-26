import 'dart:io';

import 'package:dio/dio.dart';

/// IO platforms: read file bytes and build a Dio [MultipartFile].
Future<MultipartFile?> dioMultipartFromLocalPath(String path) async {
  try {
    final f = File(path);
    if (!await f.exists()) return null;
    final bytes = await f.readAsBytes();
    final name = path.split(Platform.pathSeparator).last;
    return MultipartFile.fromBytes(bytes, filename: name);
  } catch (_) {
    return null;
  }
}
