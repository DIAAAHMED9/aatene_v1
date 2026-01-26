import 'dart:io';
import 'package:cross_file/cross_file.dart';

Future<bool> xfileExists(XFile file) async {
  final path = file.path;
  if (path.isEmpty) return false;
  return File(path).exists();
}

Future<void> xfileDelete(XFile file) async {
  final path = file.path;
  if (path.isEmpty) return;
  final f = File(path);
  if (await f.exists()) {
    await f.delete();
  }
}
