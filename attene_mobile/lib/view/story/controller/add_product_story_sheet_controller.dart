import '../../../general_index.dart';
import '../index.dart';

class AddProductStorySheetController extends GetxController {
  final RxString query = ''.obs;

  final TextEditingController searchController = TextEditingController();

  final RxList<dynamic> products = <dynamic>[].obs;

  final Rx<dynamic> selectedProduct = Rx<dynamic>(null);

  final RxBool isLoading = false.obs;

  List<dynamic> _original = [];

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      query.value = searchController.text;
      _applyLocalFilter();
    });

    loadProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      if (Get.isRegistered<ProductController>()) {
        final pc = Get.find<ProductController>();

        final dynamic list = _tryReadProductsFromController(pc);

        if (list is List) {
          products.assignAll(list);
          _original = List<dynamic>.from(list);
        } else {
          products.clear();
          _original = [];
        }
      } else {
        products.clear();
        _original = [];
      }
    } catch (e) {
      print('❌ [STORY PRODUCT] load error: $e');
      products.clear();
      _original = [];
    } finally {
      isLoading.value = false;
    }
  }

  dynamic _tryReadProductsFromController(dynamic pc) {
    try {
      final v = pc.filteredProducts;
      return v;
    } catch (_) {}

    try {
      final v = pc.products;
      return v;
    } catch (_) {}

    try {
      final v = pc.productList;
      return v;
    } catch (_) {}

    try {
      final v = pc.items;
      return v;
    } catch (_) {}

    return null;
  }

  void _applyLocalFilter() {
    final String q = query.value.trim().toLowerCase();
    if (q.isEmpty) {
      products.assignAll(_original);
      return;
    }

    final filtered = _original.where((p) {
      final String name = _getProductTitle(p).toLowerCase();
      return name.contains(q);
    }).toList();

    products.assignAll(filtered);
  }

  void select(dynamic product) {
    selectedProduct.value = product;
  }

  void onOpenFilters() {
    // TODO: ربط الفلاتر مع شاشة المنتجات الحالية لديك
  }

  void onPublish() {
    final p = selectedProduct.value;
    if (p == null) return;

    final id = _getProductId(p);
    final title = _getProductTitle(p);
    final img = _getProductImageUrl(p);

    Get.back(
      result: StoryProductPickResult(
        productId: id,
        title: title,
        imageUrl: img,
      ),
    );
  }

  String _getProductId(dynamic p) {
    try {
      final v = p.id;
      return v.toString();
    } catch (_) {}
    try {
      final v = p['id'];
      return v.toString();
    } catch (_) {}
    return '';
  }

  String _getProductTitle(dynamic p) {
    try {
      final v = p.title;
      return (v ?? '').toString();
    } catch (_) {}
    try {
      final v = p.name;
      return (v ?? '').toString();
    } catch (_) {}
    try {
      final v = p['title'] ?? p['name'];
      return (v ?? '').toString();
    } catch (_) {}
    return 'منتج';
  }

  String? _getProductImageUrl(dynamic p) {
    try {
      final v = p.imageUrl;
      return v?.toString();
    } catch (_) {}
    try {
      final v = p.image;
      return v?.toString();
    } catch (_) {}
    try {
      final v = p['image_url'] ?? p['image'];
      return v?.toString();
    } catch (_) {}
    return null;
  }
}
