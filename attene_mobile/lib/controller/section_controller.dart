// lib/controller/section_controller.dart
import 'package:attene_mobile/api/api_request.dart';
import 'package:get/get.dart';
// إضافة هذه النماذج في أعلى الملف بعد الاستيرادات
// إضافة هذه النماذج في أعلى الملف بعد الاستيرادات
class Section {
  final int id;
  final String name;
  final String? image;
  final String? imageUrl;
  final String storeId;

  Section({
    required this.id,
    required this.name,
    this.image,
    this.imageUrl,
    required this.storeId,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      imageUrl: json['image_url'],
      storeId: json['store_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'image_url': imageUrl,
      'store_id': storeId,
    };
  }
}

class Product {
  final int id;
  final String sku;
  final String name;
  final String? slug;
  final String? shortDescription;
  final String? cover;
  final String? coverUrl;
  final String? endDate;
  final bool shown;
  final String favoritesCount;
  final String messagesCount;
  final String? viewCount;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    this.slug,
    this.shortDescription,
    this.cover,
    this.coverUrl,
    this.endDate,
    required this.shown,
    required this.favoritesCount,
    required this.messagesCount,
    this.viewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'],
      shortDescription: json['short_description'],
      cover: json['cover'],
      coverUrl: json['cover_url'],
      endDate: json['end_date'],
      shown: json['shown'] ?? false,
      favoritesCount: json['favorites_count']?.toString() ?? '0',
      messagesCount: json['messages_count']?.toString() ?? '0',
      viewCount: json['view_count']?.toString(),
    );
  }
}
class SectionController extends GetxController {
  final RxList<Section> sections = <Section>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Section?> selectedSection = Rx<Section?>(null);

  @override
  void onInit() {
    super.onInit();
    loadSections();
  }

  Future<void> loadSections() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await ApiHelper.get(
        path: '/merchants/sections',
        withLoading: false,
      );
      
      if (response != null && response['status'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        sections.assignAll(data.map((section) => Section.fromJson(section)).toList());
      } else {
        errorMessage.value = 'فشل في تحميل الأقسام';
      }
    } catch (e) {
      errorMessage.value = 'خطأ في تحميل الأقسام: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addSection(String name) async {
    try {
      isLoading.value = true;
      
      final response = await ApiHelper.post(
        path: '/merchants/sections',
        body: {
          'name': name,
          'status': 'active',
        },
        withLoading: true,
      );
      
      if (response != null && response['status'] == true) {
        await loadSections(); // إعادة تحميل القائمة
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = 'خطأ في إضافة القسم: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteSection(int sectionId) async {
    try {
      isLoading.value = true;
      
      final response = await ApiHelper.delete(
        path: '/merchants/sections/$sectionId',
        withLoading: true,
      );
      
      if (response != null && response['status'] == true) {
        await loadSections(); // إعادة تحميل القائمة
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = 'خطأ في حذف القسم: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void selectSection(Section? section) {
    selectedSection.value = section;
  }

  void clearSelection() {
    selectedSection.value = null;
  }
}