import '../../../general_index.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  Product? _readProduct(dynamic args) {
    if (args is Product) return args;
    if (args is Map) {
      final m = Map<String, dynamic>.from(args);
      try {
        return Product.fromJson(m);
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
    if (args is Product) {
      final v = (args.id ?? '').toString();
      return int.tryParse(v);
    }
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
  final Product? initial;
  final int? productId;

  const _Body({required this.initial, required this.productId});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  // ✅ حطّينا كل المتغيرات المتغيرة هنا (داخل State)
  final List<String> _listColor = const ['ازرق', 'احمر', 'ابيض', 'اصفر'];
  final List<String> _listSize = const ['S', 'L', 'X', 'XXl'];
  final List<String> _listCity = const ['الناصرة', 'القدس', 'خليل'];

  bool _isChecked = false;
  bool isLiked = false;

  final _formKey = GlobalKey<FormState>();

  final ProductService _service = Get.find<ProductService>();
  final Rxn<Product> _product = Rxn<Product>();
  final RxBool _loading = false.obs;
  final RxString _error = ''.obs;

  @override
  void initState() {
    super.initState();
    _product.value = widget.initial;
    _fetchIfNeeded();
  }

  void toggleLike() {
    setState(() => isLiked = !isLiked);
  }

  Future<void> _fetchIfNeeded() async {
    final hasFull = _product.value != null && (_product.value!.coverUrl?.isNotEmpty ?? false);
    final id = widget.productId;
    if (hasFull || id == null) return;

    try {
      _loading.value = true;
      _error.value = '';
      final res = await _service.fetchProductById(
        productId: id.toString(),
        withLoading: false,
      );
      if (res != null) {
        _product.value = res;
      } else {
        _error.value = 'تعذر تحميل تفاصيل المنتج';
      }
    } catch (_) {
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

      // ✅ هنا كمل UI تبعك كما هو (Stack + باقي التصميم)
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // ضع تصميمك هنا بدون تغيير كبير
            // ...
            Text(product.name ?? product.slug ?? '', style: getBold(fontSize: 18)),
          ],
        ),
      );
    });
  }
}
