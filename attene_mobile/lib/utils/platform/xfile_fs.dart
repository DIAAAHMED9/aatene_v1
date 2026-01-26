/// Cross-platform filesystem helpers for [XFile].
///
/// Some `cross_file` versions do not expose `exists()`/`delete()` APIs.
/// Using these helpers avoids compile-time failures.

export 'xfile_fs_stub.dart'
    if (dart.library.io) 'xfile_fs_io.dart';
