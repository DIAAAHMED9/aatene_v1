import 'dart:io';

import '../../../general_index.dart';

enum StoryMediaSourceTab { studio, camera, video }

class StoryMediaPickResult {
  final StoryMediaSourceTab tab;
  final File file;

  StoryMediaPickResult({
    required this.tab,
    required this.file,
  });
}
