// lib/view/media_library/media_model.dart
enum MediaType { image, video, pdf, excel, word, other }

class MediaItem {
  final String id;
  final String path;
  final MediaType type;
  final String name;
  final DateTime dateAdded;
  final int size;
  final bool? isLocal;
  final String? fileName;
  final String? fileUrl;
  final String? userId;

  MediaItem({
    required this.id,
    required this.path,
    required this.type,
    required this.name,
    required this.dateAdded,
    required this.size,
    this.isLocal = false,
    this.fileName,
    this.fileUrl,
    this.userId,
  });

  // إضافة دالة fromApiMap محدثة
  factory MediaItem.fromApiMap(dynamic data) {
    // تحويل البيانات إلى Map<String, dynamic>
    final Map<String, dynamic> parsedData = _convertToStringMap(data);
    
    // تحديد نوع الملف من الاسم أو النوع
    MediaType determineMediaType(String? type, String? fileName) {
      if (type != null) {
        switch (type.toLowerCase()) {
          case 'image':
          case 'gallery':
          case 'avatar':
          case 'thumbnail':
            return MediaType.image;
          case 'media':
          case 'video':
            return MediaType.video;
          case 'pdf':
            return MediaType.pdf;
          case 'excel':
          case 'xlsx':
          case 'xls':
            return MediaType.excel;
          case 'word':
          case 'doc':
          case 'docx':
            return MediaType.word;
          default:
            return MediaType.other;
        }
      }
      
      // إذا لم يكن هناك type، نحدده من امتداد الملف
      if (fileName != null) {
        final extension = fileName.toLowerCase().split('.').last;
        if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension)) {
          return MediaType.image;
        } else if (['mp4', 'avi', 'mov', 'wmv', 'flv', 'mkv'].contains(extension)) {
          return MediaType.video;
        } else if (['pdf'].contains(extension)) {
          return MediaType.pdf;
        } else if (['xlsx', 'xls'].contains(extension)) {
          return MediaType.excel;
        } else if (['doc', 'docx'].contains(extension)) {
          return MediaType.word;
        }
      }
      
      return MediaType.other;
    }

    // استخراج البيانات من الاستجابة
    final String id = parsedData['id']?.toString() ?? 
                     parsedData['file_name']?.toString() ?? 
                     DateTime.now().millisecondsSinceEpoch.toString();
    
    final String name = parsedData['name'] ?? 
                       parsedData['file_name'] ?? 
                       parsedData['original_name'] ?? 
                       'unknown';
    
    final String path = parsedData['path'] ?? 
                       parsedData['url'] ?? 
                       parsedData['file_url'] ?? 
                       '';

    return MediaItem(
      id: id,
      path: path,
      type: determineMediaType(parsedData['type'], name),
      name: name,
      dateAdded: parsedData['created_at'] != null 
          ? DateTime.parse(parsedData['created_at'].toString())
          : DateTime.now(),
      size: parsedData['size'] is int 
          ? parsedData['size'] 
          : int.tryParse(parsedData['size']?.toString() ?? '0') ?? 0,
      isLocal: false,
      fileName: parsedData['file_name']?.toString(),
      fileUrl: parsedData['url']?.toString() ?? parsedData['file_url']?.toString(),
      userId: parsedData['user_id']?.toString(),
    );
  }

  // دالة مساعدة لتحويل أي خريطة إلى Map<String, dynamic>
  static Map<String, dynamic> _convertToStringMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    } else if (data is Map<dynamic, dynamic>) {
      // تحويل Map<dynamic, dynamic> إلى Map<String, dynamic>
      return data.map<String, dynamic>((key, value) {
        return MapEntry(key.toString(), value);
      });
    } else {
      return {};
    }
  }
}