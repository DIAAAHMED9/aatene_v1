import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:readmore/readmore.dart';

import '../../../general_index.dart';
import '../../support/empty.dart';

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

  // int? _readId(dynamic args) {
  //   if (args is Map) {
  //     final id = args['id'];
  //     if (id == null) return null;
  //     return int.tryParse(id.toString());
  //   }
  //   if (args is pm.Product) return int.tryParse((args.id ?? '').toString());
  //   return null;
const List<String> _listColor = ['ازرق', 'احمر', 'ابيض', 'اصفر'];
const List<String> _listSize = ['S', 'L', 'X', 'XXl'];
const List<String> _listCity = ['الناصرة', 'القدس', 'خليل'];
bool _isChecked = false;
bool isLiked = false;
final _formKey = GlobalKey<FormState>();

class _ProductDetailsState extends State<ProductDetails> {
  final isRTL = LanguageUtils.isRTL;

  void toggleLike() {
    setState(() => isLiked = !isLiked);
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
              // _ImagesCarousel(images: images),
              // const SizedBox(height: 16),
              // Text(
              //   (product.name ?? product.slug ?? ''),
              //   style: getBold(fontSize: 22),
              //   textAlign: isRTL ? TextAlign.right : TextAlign.left,
              // ),
              // const SizedBox(height: 8),
              // if ((product.price ?? '').toString().isNotEmpty)
              //   Text(
              //     '${product.price}',
              //     style: getBold(color: AppColors.primary400, fontSize: 18),
              //   ),
              // const SizedBox(height: 12),
              // _InfoRow(label: isRTL ? 'SKU' : 'SKU', value: product.sku),
              // _InfoRow(label: isRTL ? 'الحالة' : 'Status', value: product.status),
              // _InfoRow(label: isRTL ? 'القسم' : 'Section', value: product.sectionName),
              // _InfoRow(label: isRTL ? 'الوصف' : 'Description', value: product.description),
              // const SizedBox(height: 12),
              // if ((product.shortDescription ?? '').toString().isNotEmpty)
              //   Text(
              //     product.shortDescription ?? '',
              //     style: getRegular(fontSize: 14),
              //     textAlign: isRTL ? TextAlign.right : TextAlign.left,
              //   ),
              // const SizedBox(height: 12),
              // if ((product.description ?? '').toString().isNotEmpty)
              //   Text(
              //     product.description ?? '',
              //     style: getRegular(fontSize: 14),
              //     textAlign: isRTL ? TextAlign.right : TextAlign.left,
              //   ),
              // const SizedBox(height: 16),
              // if (_loading.value)
              //   const Padding(
              //     padding: EdgeInsets.symmetric(vertical: 8),
              //     child: Center(child: CircularProgressIndicator()),
              Stack(
                children: [
                  Image.asset(
                    'assets/images/png/ser1.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    height: 400,
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
                  Positioned(
                    bottom: 70,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.light1000,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("9/", style: TextStyle(fontSize: 12)),
                          Text(
                            "1",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary400,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.image_outlined),
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
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
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
                                  style: getMedium(
                                    fontSize: 14,
                                    color: AppColors.light1000,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.star, color: Colors.amberAccent),
                            Text("5.0"),
                            Text("(00)"),
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
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Armando نظارة شمس أسيتيت أصلية من أرماندو كافللي",
                      style: getBold(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        Text("الجليل . فلسطين ", style: getMedium()),
                      ],
                    ),
                    ReadMoreText(
                      'A paragraph is a unit of text that consists of a group of sentences related to a central topic or idea. It serves as a container for expressing a complete thought or developing a specific aspect of an argument.',
                      trimMode: TrimMode.Line,
                      trimLines: 2,
                      colorClickableText: AppColors.neutral500,
                      trimCollapsedText: 'عرض المزيد',
                      trimExpandedText: 'عرض أقل',
                      moreStyle: getBold(
                        fontSize: 14,
                        color: AppColors.primary400,
                      ),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Expanded(
                          child: CustomDropdown<String>(
                            hintText: 'اختر المقاس',
                            items: _listSize,
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
                            initialItem: _listSize[0],
                            onChanged: (value) {
                              print('changing value to: $value');
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomDropdown<String>(
                            hintText: 'اختر اللون',
                            items: _listColor,
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
                            initialItem: _listColor[0],
                            onChanged: (value) {
                              print('changing value to: $value');
                            },
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Text(" السعر", style: getMedium(fontSize: 13)),
                        Text(" 190.54 ₪", style: getBold(fontSize: 24)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
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
                    SizedBox(height: 20),

                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.primary50,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 30,
                                  color: AppColors.neutral300,
                                ),
                                Text(
                                  "اعجبني",
                                  style: getMedium(color: AppColors.neutral400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.primary50,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/svg_images/share.svg",
                                  width: 30,
                                  height: 30,
                                  color: AppColors.neutral300,
                                ),
                                Text(
                                  "مشاركه",
                                  style: getMedium(color: AppColors.neutral400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.primary50,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_border_rounded,
                                  size: 40,
                                  color: AppColors.neutral300,
                                ),
                                Text(
                                  "تقيم",
                                  style: getMedium(color: AppColors.neutral400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: AppColors.primary50,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.flag_outlined,
                                  size: 30,
                                  color: AppColors.neutral300,
                                ),
                                Text(
                                  "إبلاغ",
                                  style: getMedium(color: AppColors.neutral400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      maintainState: true,
                      title: Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            padding: EdgeInsets.all(8),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
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
                          Text("معلومات التوصيل", style: getMedium()),
                        ],
                      ),
                      children: [
                        Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                spacing: 20,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(15),
                                    ),

                                    child: SvgPicture.asset(
                                      "assets/images/svg_images/Calendar12.svg",
                                      width: 22,
                                      height: 22,
                                    ),
                                  ),
                                  Text(
                                    overflow: TextOverflow.ellipsis,
                                    "يتم التوصيل خلال 1–4 أيام ",
                                    style: getBold(),
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
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/svg_images/car.svg",
                                      width: 28,
                                      height: 28,
                                      color: AppColors.neutral500,
                                    ),

                                    Text(
                                      "توصيل إلي الناصرة من 2-3 أيام",
                                      style: getBold(),
                                    ),
                                    Spacer(),
                                    Text(
                                      "1200.0 ₪",
                                      style: getMedium(
                                        color: AppColors.primary400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  padding: EdgeInsets.all(5),

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
                                Text(
                                  "التوصيل إلى: ",
                                  style: getBold(fontSize: 18),
                                ),
                                Expanded(
                                  child: CustomDropdown<String>(
                                    hintText: 'اختر المدينة',
                                    items: _listCity,
                                    decoration: CustomDropdownDecoration(
                                      hintStyle: getMedium(
                                        fontSize: 12,
                                        color: AppColors.primary400,
                                      ),
                                      closedBorderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      closedBorder: Border.all(
                                        color: AppColors.primary100,
                                      ),
                                      closedSuffixIcon: Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: AppColors.primary400,
                                      ),
                                    ),
                                    initialItem: _listCity[0],
                                    onChanged: (value) {
                                      print('changing value to: $value');
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: AppColors.primary50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      padding: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary400,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/images/svg_images/city_delevery.svg",
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    Text(
                                      "شركة مرسال للتوصيل ",
                                      style: getBold(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      maintainState: true,
                      title: Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            padding: EdgeInsets.all(8),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                topLeft: Radius.circular(100),
                              ),
                              color: AppColors.primary50,
                            ),
                            child: SvgPicture.asset(
                              "assets/images/svg_images/bag-2.svg",
                              width: 18,
                              height: 18,
                            ),
                          ),
                          Text("عروض", style: getMedium()),
                        ],
                      ),
                      children: [],
                    ),
                    ExpansionTile(
                      maintainState: true,
                      title: Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
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
                          Text("معلومات عن التاجر", style: getMedium()),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary50,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("محمد علي", style: getBold()),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: AppColors.primary400,
                                                size: 15,
                                              ),
                                              Text(
                                                "فلسطين, الخليل",
                                                style: getMedium(
                                                  color: AppColors.primary400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      MaterialButton(
                                        onPressed: () {},
                                        child: Container(
                                          width: 60,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary400,
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            spacing: 5,
                                            children: [
                                              Icon(
                                                Icons.person_add_alt,
                                                color: AppColors.light1000,
                                                size: 15,
                                              ),
                                              Text(
                                                "متابعة",
                                                style: getMedium(
                                                  color: AppColors.light1000,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // MaterialButton(
                                      //   onPressed: () {},
                                      //   child: Container(
                                      //     width: 100,
                                      //     height: 25,
                                      //     decoration: BoxDecoration(
                                      //       color: AppColors.error200,
                                      //       borderRadius: BorderRadius.circular(
                                      //         50,
                                      //       ),
                                      //     ),
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //       spacing: 5,
                                      //       children: [
                                      //         Icon(
                                      //           Icons.flag_outlined,
                                      //           color: AppColors.light1000,
                                      //           size: 15,
                                      //         ),
                                      //         Text(
                                      //           "بلغ عن إساءة",
                                      //           style: TextStyle(
                                      //             color: AppColors.light1000,
                                      //             fontSize: 12,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Divider(
                                    color: AppColors.primary50,
                                    height: 2,
                                  ),
                                  Row(
                                    spacing: 5,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/svg_images/timer.svg",
                                        width: 16,
                                        height: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("عضو منذ ", style: getMedium()),
                                          Text(
                                            " 19-03-2025 ",
                                            style: getMedium(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.star_border_rounded),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            " تقيم التاجر",
                                            style: getMedium(),
                                          ),
                                          Text("5.0", style: getMedium()),
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
                    ExpansionTile(
                      maintainState: true,
                      title: Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
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
                          Text("مواصفات المنتج", style: getMedium()),
                        ],
                      ),
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "وصف موجز: سماعة استريو logitech crystal audio للبيع كالجديدة استخدام بسيط جدا وارد الخارج بنصف الثمن سعرها 8000 بدون فصال نهائي لعدم تضيع الوقت",
                            style: getMedium(
                              fontSize: 13,
                              color: AppColors.neutral500,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    ExpansionTile(
                      maintainState: true,
                      title: Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
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
                          Text("تقييمات ومراجعات", style: getMedium()),
                        ],
                      ),
                      children: [
                        Column(
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            RatingSummaryWidget(
                              rating: 4.2,
                              totalReviews: 1280,
                              ratingCount: const [20, 15, 5, 4, 2],
                            ),

                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "التعليقات",
                                      style: getBold(fontSize: 24),
                                    ),
                                    Text(
                                      "سيتم عرض جميع التعليقات هنا",
                                      style: getMedium(
                                        fontSize: 14,
                                        color: AppColors.neutral500,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Text("كل التعليقات", style: getMedium()),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.primary50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing: 12,
                                      children: [
                                        CircleAvatar(),
                                        Column(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "لويس فاندسون",
                                              style: getBold(),
                                            ),
                                            Text(
                                              "09:00 - 20 أكتوبر 2022",
                                              style: getMedium(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.flag_outlined,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "واه ، مشروعك يبدو رائع! . منذ متى وأنت ترميز؟ . ما زلت جديدًا ، لكن أعتقد أنني أريد الغوص في رد الفعل قريبًا أيضًا. ربما يمكنك أن تعطيني نظرة ثاقبة حول المكان الذي يمكنني أن أتعلم فيه رد الفعل؟ . شكرًا!",
                                      style: getMedium(
                                        color: AppColors.neutral400,
                                      ),
                                    ),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Text(
                                          "الجودة",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التواصل",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التسليم ",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                      ],
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColors.primary50,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(),
                                            Text(
                                              "لوريم إيبسوم ألم سيت أميت، كونسيكتيور أديبي سكينج إليت، سيد ديام نونومي نيبه إيسمود تينسيدونت أوت لاوريت دولور ماجن. لوريم إيبسوم ألم سيت أميت، كونسيكتيور أديبي سكينج إليت، سيد ديام نونومي نيبه إيسمود تينسيدونت أوت لاوريت ",
                                              style: getMedium(
                                                color: AppColors.neutral600,
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () {},
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.flag_outlined,
                                                    color: AppColors.error200,
                                                  ),
                                                  Text(
                                                    "بلغ عن إساءة",
                                                    style: getBold(
                                                      color: AppColors.error200,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.primary50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing: 12,
                                      children: [
                                        CircleAvatar(),
                                        Column(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "لويس فاندسون",
                                              style: getBold(),
                                            ),
                                            Text(
                                              "09:00 - 20 أكتوبر 2022",
                                              style: getMedium(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        MaterialButton(
                                          onPressed: () {},
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.flag_outlined,
                                                color: AppColors.error200,
                                              ),
                                              Text(
                                                "بلغ عن إساءة",
                                                style: getBold(
                                                  color: AppColors.error200,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "واه ، مشروعك يبدو رائع! . منذ متى وأنت ترميز؟ . ما زلت جديدًا ، لكن أعتقد أنني أريد الغوص في رد الفعل قريبًا أيضًا. ربما يمكنك أن تعطيني نظرة ثاقبة حول المكان الذي يمكنني أن أتعلم فيه رد الفعل؟ . شكرًا!",
                                      style: getMedium(
                                        color: AppColors.neutral400,
                                      ),
                                    ),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Text(
                                          "الجودة",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التواصل",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                        Spacer(),
                                        Text(
                                          "التسليم ",
                                          style: getBold(fontSize: 13),
                                        ),
                                        Icon(Icons.star, color: Colors.orange),
                                        Text("4.2"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            " مفيد 5m",
                                            style: getMedium(
                                              color: AppColors.primary400,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                            "assets/images/svg_images/message-2.svg",
                                            width: 16,
                                            height: 16,
                                          ),
                                        ),
                                        Text(
                                          "رد",
                                          style: getBold(
                                            color: AppColors.neutral600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AateneButton(
                                      buttonText: "أضف تعليقك",
                                      borderColor: AppColors.primary400,
                                      textColor: AppColors.primary400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      maintainState: true,
                      title: Row(
                        spacing: 10,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
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
                          Text("العلامات", style: getMedium()),
                        ],
                      ),
                      children: [
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.grey[100],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "Muse",
                                          style: getMedium(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TitleHome(
                      title: "المتاجر المميزة",
                      subtitle:
                          "أفضل المنتجات مبيعاً من بائعين موثوق بهم | ممول",
                    ),
                    VendorCard(),

                    TitleHome(
                      title: "منتجات تم تخصيصها لك",
                      subtitle:
                          "أفضل المنتجات مبيعاً من بائعين موثوق بهم | ممول",
                    ),
                    ProductCard(),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.primary50),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: SvgPicture.asset(
                            "assets/images/svg_images/message-butt.svg",
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () {},
                          label: Text('دردش', style: getMedium()),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: AppColors.primary400,
                          width: 2,
                        ),
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
