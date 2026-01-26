import 'dart:convert';
import 'package:image_picker/image_picker.dart';

/// =====================
/// Robust parsing helpers
/// =====================
int _toInt(dynamic v, {int defaultValue = 0}) {
  if (v == null) return defaultValue;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) {
    final s = v.trim();
    if (s.isEmpty) return defaultValue;
    return int.tryParse(s) ?? double.tryParse(s)?.toInt() ?? defaultValue;
  }
  return int.tryParse(v.toString()) ?? defaultValue;
}

double _toDouble(dynamic v, {double defaultValue = 0.0}) {
  if (v == null) return defaultValue;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();
  if (v is String) {
    final s = v.trim();
    if (s.isEmpty) return defaultValue;
    return double.tryParse(s) ?? defaultValue;
  }
  return double.tryParse(v.toString()) ?? defaultValue;
}

String _toStr(dynamic v, {String defaultValue = ''}) {
  if (v == null) return defaultValue;
  if (v is String) return v;
  return v.toString();
}

bool _toBool(dynamic v, {bool defaultValue = false}) {
  if (v == null) return defaultValue;
  if (v is bool) return v;
  final s = v.toString().trim().toLowerCase();
  if (s == '1' || s == 'true' || s == 'yes') return true;
  if (s == '0' || s == 'false' || s == 'no') return false;
  return defaultValue;
}

/// يقبل:
/// - List<dynamic> (Strings أو Maps فيها title)
/// - String JSON Array
/// - String comma-separated
List<String> _asStringList(dynamic v) {
  if (v == null) return <String>[];

  if (v is List) {
    return v
        .map((e) {
          if (e is Map && e['title'] != null) return e['title'].toString();
          if (e is Map && e['name'] != null) return e['name'].toString();
          return e.toString();
        })
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  if (v is Map && v['data'] is List) {
    return _asStringList(v['data']);
  }

  if (v is String) {
    final s = v.trim();
    if (s.isEmpty) return <String>[];

    // JSON array?
    if (s.startsWith('[') && s.endsWith(']')) {
      try {
        final decoded = jsonDecode(s);
        if (decoded is List) return _asStringList(decoded);
      } catch (_) {}
    }

    // comma-separated
    if (s.contains(',')) {
      return s
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
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
        if (decoded is List) return _asMapList(decoded);
      } catch (_) {}
    }
  }

  if (v is Map && v['data'] is List) {
    return _asMapList(v['data']);
  }

  return <Map<String, dynamic>>[];
}

class FAQ {
  final int id;
  final String question;
  final String answer;

  FAQ({required this.id, required this.question, required this.answer});

  Map<String, dynamic> toJson() => {'id': id, 'question': question, 'answer': answer};

  Map<String, dynamic> toApiJson() => {'question': question, 'answer': answer};

  factory FAQ.fromApiJson(Map<String, dynamic> json) {
    return FAQ(
      id: _toInt(json['id']),
      question: _toStr(json['question']),
      answer: _toStr(json['answer']),
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || (other is FAQ && other.id == id);

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
      id: _toInt(json['id']),
      title: _toStr(json['title']),
      price: _toDouble(json['price']),
      executionTime: _toInt(json['execute_count']),
      timeUnit: _convertTimeUnitFromApi(_toStr(json['execute_type'], defaultValue: 'hour')),
    );
  }

  static String _convertTimeUnitToApi(String timeUnit) {
    const mapping = {
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
    const mapping = {
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
  final XFile? file;

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
    XFile? file,
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

  /// مسارات نسبية غالباً: gallery/... أو images/...
  final List<String> images;

  /// روابط كاملة (من show): images_urls/images_url
  final List<String> imagesUrl;

  final String description;
  final List<FAQ> questions;

  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.acceptedTerms = false,
    this.acceptedPrivacy = false,
  });

  factory Service.fromApiJson(Map<String, dynamic> json) {
    final imagesList = _asStringList(json['images']);

    // Backend may return images_url OR images_urls
    final imagesUrlList = _asStringList(json['images_urls'] ?? json['images_url']);

    // ✅ tags/specialties: show endpoint returns objects, list endpoint may return strings
    final tags = _asStringList(json['tags']);
    final specialties = _asStringList(json['specialties']);

    return Service(
      id: json['id'] == null ? null : _toInt(json['id'], defaultValue: 0),
      slug: _toStr(json['slug']),
      title: _toStr(json['title']),
      sectionId: _toInt(json['section_id'], defaultValue: 0),
      categoryId: _toInt(json['category_id'], defaultValue: 0),
      specialties: specialties,
      tags: tags,
      storeId: json['store_id']?.toString(),
      status: _toStr(json['status'], defaultValue: 'pending'),
      price: _toDouble(json['price']),
      executeType: _toStr(json['execute_type'], defaultValue: 'hour'),
      executeCount: _toInt(json['execute_count']),
      extras: _asMapList(json['extras']).map((e) => Development.fromApiJson(e)).toList(),
      images: imagesList,
      imagesUrl: imagesUrlList,
      description: _toStr(json['description']),
      questions: _asMapList(json['questions']).map((q) => FAQ.fromApiJson(q)).toList(),
      createdAt: DateTime.tryParse(_toStr(json['created_at'])),
      updatedAt: DateTime.tryParse(_toStr(json['updated_at'])),
      acceptedTerms: _toBool(json['accepted_terms'], defaultValue: false),
      acceptedPrivacy: _toBool(json['accepted_privacy'], defaultValue: false),
    );
  }

  Map<String, dynamic> toApiJson({bool forUpdate = false, String? storeIdOverride}) {
    final data = <String, dynamic>{
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
      'accepted_terms': acceptedTerms,
      'accepted_privacy': acceptedPrivacy,
    };

    final sid = storeIdOverride ?? storeId;
    if (!forUpdate && sid != null && sid.isNotEmpty) {
      data['store_id'] = sid;
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
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
    );
  }
}