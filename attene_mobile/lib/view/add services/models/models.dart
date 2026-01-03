import 'dart:convert';
import 'dart:io';

class FAQ {
  final int id;
  final String question;
  final String answer;

  FAQ({required this.id, required this.question, required this.answer});

  Map<String, dynamic> toJson() {
    return {'id': id, 'question': question, 'answer': answer};
  }

  Map<String, dynamic> toApiJson() {
    return {'question': question, 'answer': answer};
  }

  factory FAQ.fromApiJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'] as int? ?? 0,
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FAQ && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Development {
  int id;
  String title;
  double price;
  int executionTime;
  String timeUnit;

  Development({
    required this.id,
    required this.title,
    required this.price,
    required this.executionTime,
    required this.timeUnit,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'executionTime': executionTime,
      'timeUnit': timeUnit,
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      'title': title,
      'price': price,
      'execute_count': executionTime,
      'execute_type': _convertTimeUnitToApi(timeUnit),
    };
  }

  factory Development.fromApiJson(Map<String, dynamic> json) {
    return Development(
      id: json['id'] as int? ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      executionTime: json['execute_count'] as int? ?? 0,
      timeUnit: _convertTimeUnitFromApi(json['execute_type'] ?? 'hour'),
    );
  }

  static String _convertTimeUnitToApi(String timeUnit) {
    final Map<String, String> mapping = {
      'ساعة': 'hour',
      'دقيقة': 'min',
      'يوم': 'day',
      'أسبوع': 'week',
      'شهر': 'month',
      'سنة': 'year',
    };
    return mapping[timeUnit] ?? 'hour';
  }

  static String _convertTimeUnitFromApi(String apiTimeUnit) {
    final Map<String, String> mapping = {
      'min': 'دقيقة',
      'hour': 'ساعة',
      'day': 'يوم',
      'week': 'أسبوع',
      'month': 'شهر',
      'year': 'سنة',
    };
    return mapping[apiTimeUnit] ?? 'ساعة';
  }
}

class ServiceImage {
  final int id;
  final String url;
  bool isMain;
  final bool isLocalFile;
  final File? file;

  ServiceImage({
    required this.id,
    required this.url,
    this.isMain = false,
    required this.isLocalFile,
    this.file,
  });

  ServiceImage copyWith({
    int? id,
    String? url,
    bool? isMain,
    bool? isLocalFile,
    File? file,
  }) {
    return ServiceImage(
      id: id ?? this.id,
      url: url ?? this.url,
      isMain: isMain ?? this.isMain,
      isLocalFile: isLocalFile ?? this.isLocalFile,
      file: file ?? this.file,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'isMain': isMain, 'isLocalFile': isLocalFile};
  }
}

class Service {
  final int? id;
  final String slug;
  final String title;

  final int sectionId;
  final int categoryId;

  final List<String> specialties;
  final List<String> tags;

  final String? storeId;
  final String status;

  final double price;
  final String executeType;
  final int executeCount;

  final List<Development> extras;

  /// images: مسارات نسبية غالباً (images/xxx.jpg) أو قد تأتي List
  final List<String> images;

  /// imagesUrl: روابط كاملة غالباً (https://.../storage/images/xxx.jpg)
  /// ✅ هذا هو التعديل الأساسي: كانت String وأصبحت List<String>
  final List<String> imagesUrl;

  final String description;
  final List<FAQ> questions;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final bool acceptedCopyright;
  final bool acceptedTerms;
  final bool acceptedPrivacy;

  Service({
    this.id,
    required this.slug,
    required this.title,
    required this.sectionId,
    required this.categoryId,
    required this.specialties,
    required this.tags,
    this.storeId,
    this.status = 'pending',
    required this.price,
    required this.executeType,
    required this.executeCount,
    required this.extras,
    required this.images,
    required this.imagesUrl,
    required this.description,
    required this.questions,
    this.createdAt,
    this.updatedAt,
    this.acceptedCopyright = false,
    this.acceptedTerms = false,
    this.acceptedPrivacy = false,
  });

  factory Service.fromApiJson(Map<String, dynamic> json) {
    final imagesList = _asStringList(json['images']);
    final imagesUrlList = _asStringList(json['images_url']); // ✅ الرسبونس عندك List :contentReference[oaicite:1]{index=1}

    return Service(
      id: _asInt(json['id']),
      slug: (json['slug'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      sectionId: _asInt(json['section_id']) ?? 0,
      categoryId: _asInt(json['category_id']) ?? 0,

      specialties: _asStringList(json['specialties']),
      tags: _asStringList(json['tags']),

      storeId: json['store_id']?.toString(),
      status: (json['status'] ?? 'pending').toString(),
      price: _asDouble(json['price']) ?? 0.0,

      executeType: (json['execute_type'] ?? 'hour').toString(),
      executeCount: _asInt(json['execute_count']) ?? 0,

      extras: _asMapList(json['extras'])
          .map((e) => Development.fromApiJson(e))
          .toList(),

      images: imagesList,
      imagesUrl: imagesUrlList,

      description: (json['description'] ?? '').toString(),

      questions: _asMapList(json['questions'])
          .map((q) => FAQ.fromApiJson(q))
          .toList(),

      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),

      acceptedCopyright: _asBool(json['accepted_copyright']) ?? false,
      acceptedTerms: _asBool(json['accepted_terms']) ?? false,
      acceptedPrivacy: _asBool(json['accepted_privacy']) ?? false,
    );
  }

  Map<String, dynamic> toApiJson({bool forUpdate = false}) {
    final Map<String, dynamic> data = {
      'slug': slug,
      'title': title,
      'section_id': sectionId,
      'category_id': categoryId,
      'specialties': specialties,
      'tags': tags,
      'status': status,
      'price': price,
      'execute_type': executeType,
      'execute_count': executeCount,
      'extras': extras.map((e) => e.toApiJson()).toList(),
      'images': images,
      'description': description,
      'questions': questions.map((q) => q.toApiJson()).toList(),
      'accepted_copyright': acceptedCopyright,
      'accepted_terms': acceptedTerms,
      'accepted_privacy': acceptedPrivacy,
    };

    if (!forUpdate && storeId != null) {
      data['store_id'] = storeId;
    }

    return data;
  }

  Service copyWith({
    int? id,
    String? slug,
    String? title,
    int? sectionId,
    int? categoryId,
    List<String>? specialties,
    List<String>? tags,
    String? storeId,
    String? status,
    double? price,
    String? executeType,
    int? executeCount,
    List<Development>? extras,
    List<String>? images,
    List<String>? imagesUrl,
    String? description,
    List<FAQ>? questions,
    bool? acceptedCopyright,
    bool? acceptedTerms,
    bool? acceptedPrivacy,
  }) {
    return Service(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      sectionId: sectionId ?? this.sectionId,
      categoryId: categoryId ?? this.categoryId,
      specialties: specialties ?? this.specialties,
      tags: tags ?? this.tags,
      storeId: storeId ?? this.storeId,
      status: status ?? this.status,
      price: price ?? this.price,
      executeType: executeType ?? this.executeType,
      executeCount: executeCount ?? this.executeCount,
      extras: extras ?? this.extras,
      images: images ?? this.images,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      createdAt: createdAt,
      updatedAt: updatedAt,
      acceptedCopyright: acceptedCopyright ?? this.acceptedCopyright,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
    );
  }
}

/* -------------------- Helpers (Robust Parsing) -------------------- */

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  final s = v.toString().toLowerCase();
  if (s == '1' || s == 'true' || s == 'yes') return true;
  if (s == '0' || s == 'false' || s == 'no') return false;
  return null;
}

DateTime? _asDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}

/// يقبل:
/// - List<String>
/// - List<dynamic>
/// - String (comma separated)
/// - String JSON Array: '["a","b"]'
/// - Map فيه data: [...]
List<String> _asStringList(dynamic v) {
  if (v == null) return <String>[];

  if (v is List) {
    return v.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList();
  }

  if (v is Map && v['data'] is List) {
    final list = v['data'] as List;
    return list.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList();
  }

  if (v is String) {
    final s = v.trim();
    if (s.isEmpty) return <String>[];

    // JSON array?
    if (s.startsWith('[') && s.endsWith(']')) {
      try {
        final decoded = jsonDecode(s);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList();
        }
      } catch (_) {}
    }

    // comma-separated
    if (s.contains(',')) {
      return s.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }

    return <String>[s];
  }

  return <String>[];
}

List<Map<String, dynamic>> _asMapList(dynamic v) {
  if (v == null) return <Map<String, dynamic>>[];

  if (v is List) {
    return v
        .where((e) => e is Map)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  if (v is String) {
    final s = v.trim();
    if (s.startsWith('[') && s.endsWith(']')) {
      try {
        final decoded = jsonDecode(s);
        if (decoded is List) {
          return decoded
              .where((e) => e is Map)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
      } catch (_) {}
    }
  }

  if (v is Map && v['data'] is List) {
    final list = v['data'] as List;
    return list
        .where((e) => e is Map)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  return <Map<String, dynamic>>[];
}
