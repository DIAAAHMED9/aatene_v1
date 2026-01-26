// ignore_for_file: avoid_web_libraries_in_flutter

/// Cross-platform helper to create a Dio [MultipartFile] from a local file path.
///
/// - On IO platforms (Android/iOS/Desktop): reads bytes from the path.
/// - On Web: returns null (local paths are not accessible).

export 'dio_multipart_stub.dart'
    if (dart.library.io) 'dio_multipart_io.dart';
