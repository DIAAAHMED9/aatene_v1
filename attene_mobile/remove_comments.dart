import 'dart:io';

void main() async {
  final directory = Directory('lib');
  
  if (!await directory.exists()) {
    print('❌ مجلد lib غير موجود!');
    return;
  }
  
  print('🔍 بدء عملية تنظيف التعليقات...');
  await processDirectory(directory);
  print('✅ تم الانتهاء من تنظيف التعليقات!');
}

Future<void> processDirectory(Directory dir) async {
  try {
    final List<FileSystemEntity> entities = dir.listSync(recursive: true);
    
    int totalFiles = 0;
    int cleanedFiles = 0;
    
    for (final entity in entities) {
      if (entity is File && entity.path.endsWith('.dart')) {
        totalFiles++;
        final cleaned = await cleanFileComments(entity);
        if (cleaned) cleanedFiles++;
      }
    }
    
    print('📊 الإحصائيات:');
    print('   - عدد الملفات الممسوحة: $totalFiles');
    print('   - عدد الملفات التي تم تنظيفها: $cleanedFiles');
    
  } catch (e) {
    print('❌ خطأ في معالجة المجلد: $e');
  }
}

Future<bool> cleanFileComments(File file) async {
  try {
    final content = await file.readAsString();
    final cleanedContent = _removeComments(content);
    
    if (content != cleanedContent) {
      await file.writeAsString(cleanedContent);
      print('   ✅ تم تنظيف: ${file.path.split('/').last}');
      return true;
    }
    return false;
  } catch (e) {
    print('   ❌ خطأ في تنظيف ${file.path}: $e');
    return false;
  }
}

String _removeComments(String content) {
  final lines = content.split('\n');
  final List<String> cleanedLines = [];
  
  bool inMultiLineComment = false;
  bool inString = false;
  String stringChar = '';
  
  for (final line in lines) {
    if (line.trim().isEmpty) {
      cleanedLines.add(line);
      continue;
    }
    
    String currentLine = line;
    String cleanedLine = '';
    int i = 0;
    
    while (i < currentLine.length) {
      final char = currentLine[i];
      final nextChar = i + 1 < currentLine.length ? currentLine[i + 1] : '';
      
      // التحقق من حالة النصوص
      if (!inMultiLineComment && !inString && (char == '"' || char == "'")) {
        inString = true;
        stringChar = char;
        cleanedLine += char;
        i++;
        continue;
      }
      
      if (inString && char == stringChar) {
        // التحقق من الهروب
        int backslashCount = 0;
        int j = i - 1;
        while (j >= 0 && currentLine[j] == '\\') {
          backslashCount++;
          j--;
        }
        
        if (backslashCount % 2 == 0) {
          inString = false;
        }
        cleanedLine += char;
        i++;
        continue;
      }
      
      if (inString) {
        cleanedLine += char;
        i++;
        continue;
      }
      
      // التعامل مع التعليقات متعددة الأسطر
      if (!inMultiLineComment && char == '/' && nextChar == '*') {
        inMultiLineComment = true;
        i += 2;
        continue;
      }
      
      if (inMultiLineComment && char == '*' && nextChar == '/') {
        inMultiLineComment = false;
        i += 2;
        continue;
      }
      
      if (inMultiLineComment) {
        i++;
        continue;
      }
      
      // التعامل مع التعليقات أحادية السطر
      if (char == '/' && nextChar == '/') {
        // توقف عند بداية التعليق أحادي السطر
        break;
      }
      
      cleanedLine += char;
      i++;
    }
    
    // إزالة المسافات الزائدة في نهاية السطر
    cleanedLine = cleanedLine.trimRight();
    
    if (cleanedLine.isNotEmpty || line.trim().isEmpty) {
      cleanedLines.add(cleanedLine);
    }
  }
  
  // إزالة الأسطر الفارغة المتتالية
  return _removeConsecutiveEmptyLines(cleanedLines.join('\n'));
}

String _removeConsecutiveEmptyLines(String content) {
  final lines = content.split('\n');
  final List<String> result = [];
  bool lastLineEmpty = false;
  
  for (final line in lines) {
    final trimmedLine = line.trim();
    
    if (trimmedLine.isEmpty) {
      if (!lastLineEmpty) {
        result.add(line);
        lastLineEmpty = true;
      }
    } else {
      result.add(line);
      lastLineEmpty = false;
    }
  }
  
  // إزالة السطر الفارغ الأول والأخير إذا كان موجوداً
  if (result.isNotEmpty && result.first.trim().isEmpty) {
    result.removeAt(0);
  }
  
  if (result.isNotEmpty && result.last.trim().isEmpty) {
    result.removeLast();
  }
  
  return result.join('\n');
}