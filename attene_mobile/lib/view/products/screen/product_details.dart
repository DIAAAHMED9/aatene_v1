import '../../../../general_index.dart';
import '../../../../models/product_model.dart' as pm;
import '../controller/product_service.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  pm.Product? _readProduct(dynamic args) {
    if (args is pm.Product) return args;
    if (args is Map) {
      final m = Map<String, dynamic>.from(args);
      try {
        return pm.Product.fromJson(m);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  int? _readId(dynamic args) {
    if (args is Map) {
      final id = args['id'];
      if (id == null) return null;
      return int.tryParse(id.toString());
    }
    if (args is pm.Product) return int.tryParse((args.id ?? '').toString());
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    final initial = _readProduct(Get.arguments);
    final id = _readId(Get.arguments);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(isRTL ? 'تفاصيل المنتج' : 'Product details'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _Body(
        initial: initial,
        productId: id,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final pm.Product? initial;
  final int? productId;

  const _Body({required this.initial, required this.productId});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final ProductService _service = Get.find<ProductService>();
  final Rxn<pm.Product> _product = Rxn<pm.Product>();
  final RxBool _loading = false.obs;
  final RxString _error = ''.obs;

  @override
  void initState() {
    super.initState();
    _product.value = widget.initial;
    _fetchIfNeeded();
  }

  Future<void> _fetchIfNeeded() async {
    final hasFull = _product.value != null && (_product.value!.coverUrl?.isNotEmpty ?? false);
    final id = widget.productId;
    if (hasFull || id == null) return;

    try {
      _loading.value = true;
      _error.value = '';
      final res = await _service.fetchProductById(productId: id.toString(), withLoading: false);
      if (res != null) {
        _product.value = res;
      } else {
        _error.value = 'تعذر تحميل تفاصيل المنتج';
      }
    } catch (e) {
      _error.value = 'تعذر تحميل تفاصيل المنتج';
    } finally {
      _loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Obx(() {
      if (_loading.value && _product.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final product = _product.value;
      if (product == null) {
        return Center(
          child: Text(
            _error.value.isNotEmpty
                ? _error.value
                : (isRTL ? 'لا توجد بيانات لعرضها' : 'No data to display'),
            style: getRegular(fontSize: 16),
          ),
        );
      }

      final images = <String>[
        ...product.section?['images'] != null &&
                product.section!['images'] is List &&
                (product.section!['images'] as List).isNotEmpty
            ? (product.section!['images'] as List)
                .map((e) => e.toString().trim())
                .where((e) => e.isNotEmpty)
                .toList()
            : [],
        if ((product.coverUrl ?? '').trim().isNotEmpty) product.coverUrl!.trim(),
      ].toSet().toList();

      return RefreshIndicator(
        onRefresh: () async {
          if (widget.productId != null) {
            await _fetchIfNeeded();
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              _ImagesCarousel(images: images),
              const SizedBox(height: 16),
              Text(
                (product.name ?? product.slug ?? ''),
                style: getBold(fontSize: 22),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 8),
              if ((product.price ?? '').toString().isNotEmpty)
                Text(
                  '${product.price}',
                  style: getBold(color: AppColors.primary400, fontSize: 18),
                ),
              const SizedBox(height: 12),
              _InfoRow(label: isRTL ? 'SKU' : 'SKU', value: product.sku),
              _InfoRow(label: isRTL ? 'الحالة' : 'Status', value: product.status),
              _InfoRow(label: isRTL ? 'القسم' : 'Section', value: product.sectionName),
              _InfoRow(label: isRTL ? 'الوصف' : 'Description', value: product.description),
              const SizedBox(height: 12),
              if ((product.shortDescription ?? '').toString().isNotEmpty)
                Text(
                  product.shortDescription ?? '',
                  style: getRegular(fontSize: 14),
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                ),
              const SizedBox(height: 12),
              if ((product.description ?? '').toString().isNotEmpty)
                Text(
                  product.description ?? '',
                  style: getRegular(fontSize: 14),
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                ),
              const SizedBox(height: 16),
              if (_loading.value)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const _InfoRow({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    final v = (value ?? '').toString().trim();
    if (v.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label: ', style: getMedium(fontSize: 13)),
          Expanded(child: Text(v, style: getRegular(fontSize: 13))),
        ],
      ),
    );
  }
}

class _ImagesCarousel extends StatelessWidget {
  final List<String> images;

  const _ImagesCarousel({required this.images});

  @override
  Widget build(BuildContext context) {
    final items = images
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (items.isEmpty) {
      return Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.image_not_supported),
      );
    }

    return SizedBox(
      height: 220,
      child: PageView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final url = items[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.broken_image),
                );
              },
            ),
          );
        },
      ),
    );
  }
}