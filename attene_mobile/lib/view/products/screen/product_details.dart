import 'dart:convert';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../general_index.dart';
import '../../profile/user profile/widget/rating_profile_screen.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final bool isRTL = LanguageUtils.isRTL;
  final args = Get.arguments;

  final List<String> _listColor = const ['ازرق', 'احمر', 'ابيض', 'اصفر'];
  final List<String> _listSize = const ['S', 'L', 'X', 'XXl'];
  final List<String> _listCity = const ['الناصرة', 'القدس', 'خليل'];

  bool isLiked = false;
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();

  final ProductService _productService = Get.find<ProductService>();
  Map<String, dynamic> productData = {};

  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();

    final dynamic rawSlug = (args is Map)
        ? (args['slug'] ?? args['slag'] ?? args['productSlug'])
        : null;
    final dynamic rawId = (args is Map)
        ? (args['productId'] ?? args['id'])
        : null;

    final String slug = (rawSlug ?? '').toString();
    final String idStr = (rawId ?? '').toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.previousRoute == '/mainScreen') {
        _loadProductBySlug(slug);
      } else {
        _loadProductById(idStr);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void toggleLike() {
    setState(() => isLiked = !isLiked);
  }

  Future<void> _loadProductBySlug(String slug) async {
    try {
      setState(() => isLoading = true);

      await _productService.fetchProductBySlug(slug: slug, withLoading: false);
    } catch (e) {
      print('Error loading product: $e');
      Get.snackbar('خطأ', 'فشل في تحميل بيانات المنتج');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadProductById(String idStr) async {
    try {
      setState(() => isLoading = true);

      final int id = int.tryParse(idStr) ?? 0;
      if (id == 0) {
        throw Exception('Missing product id/slug');
      }

      await _productService.fetchProductById(productId: id, withLoading: false);
    } catch (e) {
      print('Error loading product: $e');
      Get.snackbar('خطأ', 'فشل في تحميل بيانات المنتج');
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _toUrl(String path) {
    final p = path.trim();
    if (p.isEmpty) return '';
    if (p.startsWith('http://') || p.startsWith('https://')) return p;

    final clean = p.startsWith('/') ? p.substring(1) : p;
    const base = 'https://aatene.dev/storage/';
    return '$base$clean';
  }

  List<String> _collectImages(Map<String, dynamic> product) {
    final out = <String>[];

    void addOne(dynamic v) {
      final s = (v ?? '').toString().trim();
      if (s.isNotEmpty && s != 'https://aatene.dev/storage') {
        out.add(s);
      }
    }

    void addMany(dynamic v) {
      if (v == null) return;
      if (v is List) {
        for (final e in v) {
          addOne(e);
        }
      } else {
        addOne(v);
      }
    }

    try {
      final dynamic dyn = product as dynamic;
      final dynamic all = dyn.allImageUrls;
      addMany(all);
    } catch (_) {}

    addOne(product['cover']);
    addOne(product['cover_url']);

    try {
      final dynamic dyn = product as dynamic;
      addMany(dyn.galleryUrls);
      addMany(dyn.gallery_url);
      addMany(dyn.galleryUrl);
      addMany(dyn.gallery_urls);
    } catch (_) {}

    try {
      final dynamic dyn = product as dynamic;
      addMany(dyn.images);
      addMany(dyn.images_url);
      addMany(dyn.imagesUrls);
    } catch (_) {}

    final normalized = <String>[];
    for (final s in out) {
      normalized.add(_toUrl(s));
    }

    return normalized.toSet().toList();
  }

  String? _extractStoreId(Map<String, dynamic> product) {
    try {
      if (product['store'] != null && product['store'] is Map) {
        final store = product['store'] as Map<String, dynamic>;
        if (store['id'] != null) {
          return store['id'].toString();
        }
      }

      if (product['section'] != null && product['section'] is Map) {
        final section = product['section'] as Map<String, dynamic>;
        if (section['store_id'] != null) {
          return section['store_id'].toString();
        }
      }

      final storeId = product['store_id'] ?? product['storeId'];
      if (storeId != null) return storeId.toString();

      return null;
    } catch (e) {
      print('Error extracting store id: $e');
      return null;
    }
  }

  List<String> _extractTags(Map<String, dynamic> product) {
    final dynamic raw = product['tags'];

    if (raw == null) return <String>[];

    if (raw is String) {
      final s = raw.trim();
      if (s.isEmpty) return <String>[];
      try {
        final decoded = json.decode(s);
        if (decoded is List) {
          return decoded
              .map((e) => _tagToString(e))
              .where((e) => e.isNotEmpty)
              .toList();
        }
      } catch (_) {}
      return s
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    if (raw is List) {
      return raw
          .map((e) => _tagToString(e))
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final one = _tagToString(raw);
    return one.isEmpty ? <String>[] : <String>[one];
  }

  String _tagToString(dynamic e) {
    if (e == null) return '';
    if (e is String) return e.trim();
    if (e is Map) {
      final v = e['name'] ?? e['title'] ?? e['label'] ?? e['value'];
      return (v ?? '').toString().trim();
    }
    return e.toString().trim();
  }

  String _extractReviewRate(Map<String, dynamic> product) {
    try {
      final dynamic dyn = product as dynamic;
      final r = dyn.reviewRate ?? dyn.review_rate;
      final s = (r ?? '').toString().trim();
      if (s.isNotEmpty) return s;
    } catch (_) {}
    return '0';
  }

  String _extractReviewCount(Map<String, dynamic> product) {
    try {
      final count = product['review_count'] ?? '0';
      return count.toString();
    } catch (_) {
      return '0';
    }
  }

  String _extractStoreName(Map<String, dynamic> product) {
    try {
      if (product['store'] != null && product['store'] is Map) {
        final store = product['store'] as Map<String, dynamic>;
        return store['name']?.toString() ?? 'اسم المتجر';
      }
      return 'اسم المتجر';
    } catch (_) {
      return 'اسم المتجر';
    }
  }

  String _extractStoreAddress(Map<String, dynamic> product) {
    try {
      if (product['store'] != null && product['store'] is Map) {
        final store = product['store'] as Map<String, dynamic>;
        return store['address']?.toString() ?? 'العنوان غير متوفر';
      }
      return 'العنوان غير متوفر';
    } catch (_) {
      return 'العنوان غير متوفر';
    }
  }

  String _extractStoreReviewRate(Map<String, dynamic> product) {
    try {
      if (product['store'] != null && product['store'] is Map) {
        final store = product['store'] as Map<String, dynamic>;
        return store['review_rate']?.toString() ?? '0';
      }
      return '0';
    } catch (_) {
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<ProductService>(
          builder: (ProductService controller) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final product = controller.productData;

            if (product.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('المنتج غير موجود', style: getMedium()),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text('رجوع'),
                    ),
                  ],
                ),
              );
            }

            final images = _collectImages(product);
            final title = (product['name'] ?? '').toString().trim();
            final desc =
                (product['description'] ?? product['short_description'] ?? '')
                    .toString()
                    .trim();
            final price = (product['price'] ?? '').toString().trim();

            final reviewRate = _extractReviewRate(product);
            final reviewCount = _extractReviewCount(product);
            final tags = _extractTags(product);

            final storeName = _extractStoreName(product);
            final storeAddress = _extractStoreAddress(product);
            final storeReviewRate = _extractStoreReviewRate(product);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 400,
                        child: images.isEmpty
                            ? Image.asset(
                                'assets/images/png/ser1.png',
                                width: double.infinity,
                                fit: BoxFit.cover,
                                height: 400,
                              )
                            : PageView.builder(
                                controller: _pageController,
                                itemCount: images.length,
                                onPageChanged: (i) =>
                                    setState(() => _pageIndex = i),
                                itemBuilder: (_, i) {
                                  return Image.network(
                                    images[i],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    height: 400,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/png/ser1.png',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      height: 400,
                                    ),
                                  );
                                },
                              ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey[100],
                          ),
                          child: IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppColors.neutral100,
                            ),
                          ),
                        ),
                      ),

                      if (images.isNotEmpty)
                        Positioned(
                          bottom: 70,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.light1000,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${images.length}/',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '${_pageIndex + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary400,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.image_outlined),
                              ],
                            ),
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.only(top: 360),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.light1000,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppColors.primary400,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "منتج",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.light1000,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                ),
                                Text(reviewRate),
                                Text("($reviewCount)"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.isNotEmpty
                              ? title
                              : (isRTL ? 'منتج' : 'Product'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(width: 4),
                            Text(
                              (storeAddress.isNotEmpty)
                                  ? storeAddress
                                  : "الجليل . فلسطين ",
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        ReadMoreText(
                          desc.isNotEmpty ? desc : '-',
                          trimMode: TrimMode.Line,
                          trimLines: 3,
                          colorClickableText: AppColors.neutral500,
                          trimCollapsedText: 'عرض المزيد',
                          trimExpandedText: 'عرض أقل',
                          moreStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary400,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomDropdown<String>.multiSelect(
                                hintText: 'اختر المقاس',
                                decoration: CustomDropdownDecoration(
                                  hintStyle: getMedium(fontSize: 12),
                                  closedBorderRadius: BorderRadius.circular(10),
                                  closedBorder: Border.all(
                                    color: AppColors.primary100,
                                  ),
                                  closedSuffixIcon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: AppColors.primary100,
                                  ),
                                ),
                                items: _listSize,
                                onListChanged: (value) {},
                                listValidator: (value) => value.isEmpty
                                    ? "يجب عليك الاختيار للمتابعة"
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomDropdown<String>.multiSelect(
                                hintText: 'اختر اللون',
                                decoration: CustomDropdownDecoration(
                                  hintStyle: getMedium(fontSize: 12),
                                  closedBorderRadius: BorderRadius.circular(10),
                                  closedBorder: Border.all(
                                    color: AppColors.primary100,
                                  ),
                                  closedSuffixIcon: Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: AppColors.primary100,
                                  ),
                                ),
                                items: _listColor,
                                onListChanged: (value) {},
                                listValidator: (value) => value.isEmpty
                                    ? "يجب عليك الاختيار للمتابعة"
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Text(
                              " السعر",
                              style: TextStyle(fontSize: 13),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              price.isNotEmpty ? " $price ₪" : " -",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Text(
                              "380.21 ₪",
                              style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              "  50% off ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.error200,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: toggleLike,
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: AppColors.primary50,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 30,
                                        color: isLiked
                                            ? AppColors.primary400
                                            : AppColors.neutral300,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "اعجبني",
                                        style: TextStyle(
                                          color: AppColors.neutral400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await Share.share(
                                    title.isNotEmpty ? title : 'Product',
                                    subject: 'Check out this product!',
                                  );
                                },
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: AppColors.primary50,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/svg_images/share.svg",
                                        width: 30,
                                        height: 30,
                                        color: AppColors.neutral300,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "مشاركه",
                                        style: TextStyle(
                                          color: AppColors.neutral400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: AppColors.primary50,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star_border_rounded,
                                      size: 30,
                                      color: AppColors.neutral300,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "تقيم",
                                      style: TextStyle(
                                        color: AppColors.neutral400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: AppColors.primary50,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.flag_outlined,
                                      size: 30,
                                      color: AppColors.neutral300,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "إبلاغ",
                                      style: TextStyle(
                                        color: AppColors.neutral400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        ExpansionTile(
                          maintainState: true,
                          title: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(100),
                                    topLeft: Radius.circular(100),
                                  ),
                                  color: AppColors.primary50,
                                ),
                                child: SvgPicture.asset(
                                  "assets/images/svg_images/car.svg",
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text("معلومات التوصيل"),
                            ],
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          "assets/images/svg_images/Calendar12.svg",
                                          width: 22,
                                          height: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        "يتم التوصيل خلال 1–4 أيام ",
                                        style: getBold(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/svg_images/car.svg",
                                          width: 28,
                                          height: 28,
                                          color: AppColors.neutral500,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "توصيل إلي الناصرة من 2-3 أيام",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "1200.0 ₪",
                                          style: TextStyle(
                                            color: AppColors.primary400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/images/svg_images/delivery-truck-svgrepo-com (1) 1.svg",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "التوصيل إلى: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomDropdown<String>(
                                        hintText: 'اختر المدينة',
                                        items: _listCity,
                                        decoration: CustomDropdownDecoration(
                                          hintStyle: getMedium(
                                            fontSize: 12,
                                            color: AppColors.primary400,
                                          ),
                                          closedBorderRadius:
                                              BorderRadius.circular(10),
                                          closedBorder: Border.all(
                                            color: AppColors.primary100,
                                          ),
                                          closedSuffixIcon: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: AppColors.primary400,
                                          ),
                                        ),
                                        initialItem: _listCity[0],
                                        onChanged: (value) {},
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: AppColors.primary50,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary400,
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: SvgPicture.asset(
                                            "assets/images/svg_images/city_delevery.svg",
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "شركة مرسال للتوصيل ",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ExpansionTile(
                        //   maintainState: true,
                        //   title: Row(
                        //     children: [
                        //       Container(
                        //         width: 60,
                        //         height: 40,
                        //         padding: const EdgeInsets.all(8),
                        //         decoration: BoxDecoration(
                        //           borderRadius: const BorderRadius.only(
                        //             bottomLeft: Radius.circular(100),
                        //             topLeft: Radius.circular(100),
                        //           ),
                        //           color: AppColors.primary50,
                        //         ),
                        //         child: SvgPicture.asset("assets/images/svg_images/bag-2.svg", width: 18, height: 18),
                        //       ),
                        //       const SizedBox(width: 10),
                        //       const Text("عروض"),
                        //     ],
                        //   ),
                        //   children: const [],
                        // ),
                        const SizedBox(height: 10),

                        ExpansionTile(
                          maintainState: true,
                          title: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(100),
                                    topLeft: Radius.circular(100),
                                  ),
                                  color: AppColors.primary50,
                                ),
                                child: SvgPicture.asset(
                                  "assets/images/svg_images/user.svg",
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text("معلومات عن التاجر"),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primary50,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage:
                                                product['store'] != null &&
                                                    product['store']['logo_url'] !=
                                                        null
                                                ? NetworkImage(
                                                    product['store']['logo_url']
                                                        .toString(),
                                                  )
                                                : const AssetImage(
                                                        'assets/images/png/ser1.png',
                                                      )
                                                      as ImageProvider,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  storeName.isNotEmpty
                                                      ? storeName
                                                      : "—",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color:
                                                          AppColors.primary400,
                                                      size: 15,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      storeAddress.isNotEmpty
                                                          ? storeAddress
                                                          : "—",
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .primary400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () {},
                                            child: Container(
                                              width: 60,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary400,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.person_add_alt,
                                                    color: AppColors.light1000,
                                                    size: 15,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    "متابعة",
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.light1000,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: AppColors.primary50,
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/svg_images/timer.svg",
                                            width: 16,
                                            height: 16,
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text("عضو منذ "),
                                              Text(" — "),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(Icons.star_border_rounded),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(" تقيم التاجر"),
                                              Text(
                                                product['store']['review_rate'] ??
                                                    0,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        ExpansionTile(
                          maintainState: true,
                          title: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(100),
                                    topLeft: Radius.circular(100),
                                  ),
                                  color: AppColors.primary50,
                                ),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.primary400,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text("مواصفات المنتج"),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                desc.isNotEmpty ? desc : "لا توجد مواصفات",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.neutral500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        ExpansionTile(
                          maintainState: true,
                          title: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(100),
                                    topLeft: Radius.circular(100),
                                  ),
                                  color: AppColors.primary50,
                                ),
                                child: Icon(
                                  Icons.star_border_rounded,
                                  color: AppColors.primary400,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text("تقييمات ومراجعات"),
                            ],
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                RatingProfile(productSlug: product['slug']),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        ExpansionTile(
                          maintainState: true,
                          title: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(100),
                                    topLeft: Radius.circular(100),
                                  ),
                                  color: AppColors.primary50,
                                ),
                                child: Icon(
                                  Icons.local_offer_outlined,
                                  color: AppColors.primary400,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text("العلامات"),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (tags.isEmpty)
                                    Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.grey[100],
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(
                                            "—",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    for (final t in tags)
                                      Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          color: Colors.grey[100],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Text(
                                              t,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        TitleHome(
                          title: "المتاجر المميزة",
                          subtitle:
                              "أفضل المنتجات مبيعاً من بائعين موثوق بهم | ممول",
                        ),
                        const VendorCard(store: {}),

                        const SizedBox(height: 20),

                        TitleHome(
                          title: "منتجات تم تخصيصها لك",
                          subtitle:
                              "أفضل المنتجات مبيعاً من بائعين موثوق بهم | ممول",
                        ),
                        const ProductCard(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.primary50),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton.icon(
                              icon: SvgPicture.asset(
                                "assets/images/svg_images/message-butt.svg",
                                width: 24,
                                height: 24,
                              ),
                              onPressed: () async {
                                final storeId =
                                    _extractStoreId(product)?.trim() ?? '';
                                if (storeId.isEmpty) {
                                  Get.snackbar(
                                    'خطأ',
                                    'تعذر تحديد المتجر الخاص بهذا المنتج',
                                  );
                                  return;
                                }

                                // ⚠️ لا تقم بتغيير storeId العالمي هنا.
                                // هذا الـ storeId هو صاحب المنتج (الطرف الآخر) وليس المتجر النشط للمستخدم.
                                // تخزينه في GetStorage يجعل كل طلبات الشات تعمل بسياق متجر خاطئ
                                // ويؤدي لخطأ: "أنت لست مشاركًا في هذه المحادثة".

                                final ChatController chat =
                                    Get.isRegistered<ChatController>()
                                    ? Get.find<ChatController>()
                                    : Get.put(ChatController());

                                // ✅ Postman solution #2:
                                // create/find the direct conversation by sending a first message
                                // that includes product_id.
                                // product is a Map<String, dynamic> in this screen.
                                final int pid =
                                    int.tryParse((product?['id'] ?? 0).toString()) ?? 0;
                                final String pname =
                                    (product?['name'] ?? '').toString();
                                final firstBody =
                                    pname.isNotEmpty
                                        ? 'مرحباً، بخصوص المنتج "$pname" (#$pid) هل هو متوفر؟'
                                        : 'مرحباً، بخصوص المنتج (#$pid) هل هو متوفر؟';

                                final conv =
                                    await chat.startDirectChatByFirstMessage(
                                      participantType: 'store',
                                      participantId: storeId,
                                      body: firstBody,
                                      productId: pid > 0 ? pid : null,
                                    );

                                if (conv != null) {
                                  Get.to(
                                    () => ChatDetailPage(conversation: conv),
                                  );
                                }
                              },
                              label: const Text('دردش'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColors.primary400),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.call_outlined,
                              color: AppColors.primary400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
