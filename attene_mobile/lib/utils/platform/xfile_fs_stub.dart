import 'package:cross_file/cross_file.dart';

/// Web/unsupported platforms: local file paths are not accessible.
Future<bool> xfileExists(XFile file) async {
  // Best-effort: assume it's "there" so UI actions can proceed.
  return true;
}

Future<void> xfileDelete(XFile file) async {
  // No-op on Web.
}
