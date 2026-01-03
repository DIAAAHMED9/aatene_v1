import '../api/index.dart';
import '../models/index.dart';
import 'package:get/get.dart';



import '../api/api_request.dart';
import '../models/section_model.dart';

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
        sections.assignAll(
          data.map((section) => Section.fromJson(section)).toList(),
        );
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
        body: {'name': name, 'status': 'active'},
        withLoading: true,
      );

      if (response != null && response['status'] == true) {
        await loadSections();
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
        await loadSections();
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