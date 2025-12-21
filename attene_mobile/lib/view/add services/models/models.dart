import 'dart:io';

class FAQ {
  final int id; // غير من String إلى int
  final String question;
  final String answer;
  
  FAQ({
    required this.id,
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }

  factory FAQ.fromApiJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'] as int? ?? 0, // تحويل إلى int
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
  int id; // غير من String إلى int
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
      id: json['id'] as int? ?? 0, // تحويل إلى int
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
  final int id; // غير من String إلى int
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
    return {
      'id': id,
      'url': url,
      'isMain': isMain,
      'isLocalFile': isLocalFile,
    };
  }
}

class Service {
  final int? id; // غير من String? إلى int?
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
  final List<String> images;
  final String? imagesUrl;
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
    required this.description,
    required this.questions,
     this.imagesUrl,
    this.createdAt,
    this.updatedAt,
    this.acceptedCopyright = false,
    this.acceptedTerms = false,
    this.acceptedPrivacy = false,
  });

  factory Service.fromApiJson(Map<String, dynamic> json) {
    // معالجة images لتحويلها من String مفصولة بفواصل إلى List<String>
    List<String> imagesList = [];
    if (json['images'] is String) {
      final imagesString = json['images'] as String;
      imagesList = imagesString.split(',').map((img) => img.trim()).toList();
    } else if (json['images'] is List) {
      imagesList = List<String>.from(json['images'] ?? []);
    }

    return Service(
      id: json['id'] as int?, // تأكد أنه int
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      sectionId: json['section_id'] is String 
          ? int.tryParse(json['section_id']) ?? 0
          : json['section_id'] as int? ?? 0,
      categoryId: json['category_id'] is String
          ? int.tryParse(json['category_id']) ?? 0
          : json['category_id'] as int? ?? 0,
      specialties: List<String>.from(json['specialties'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      storeId: json['store_id']?.toString(),
      status: json['status'] ?? 'pending',
      price: json['price'] is String
          ? double.tryParse(json['price']) ?? 0.0
          : (json['price'] as num?)?.toDouble() ?? 0.0,
      imagesUrl: json['images_url'],
      executeType: json['execute_type'] ?? 'hour',
      executeCount: json['execute_count'] is String
          ? int.tryParse(json['execute_count']) ?? 0
          : json['execute_count'] as int? ?? 0,
      extras: (json['extras'] as List<dynamic>?)
          ?.map((extra) => Development.fromApiJson(extra))
          .toList() ?? [],
      images: imagesList,
      description: json['description'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => FAQ.fromApiJson(q))
          .toList() ?? [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      acceptedCopyright: json['accepted_copyright'] as bool? ?? false,
      acceptedTerms: json['accepted_terms'] as bool? ?? false,
      acceptedPrivacy: json['accepted_privacy'] as bool? ?? false,
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
      'extras': extras.map((extra) => extra.toApiJson()).toList(),
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
      description: description ?? this.description,
      questions: questions ?? this.questions,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      acceptedCopyright: acceptedCopyright ?? this.acceptedCopyright,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
    );
  }
}