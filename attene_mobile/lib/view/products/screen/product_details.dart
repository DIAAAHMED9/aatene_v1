import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:attene_mobile/view/profile/vendor_profile/widget/offers.dart';
import 'package:readmore/readmore.dart';

import '../../../general_index.dart';
import '../../support/empty.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final bool isRTL = LanguageUtils.isRTL;

  final List<String> _listColor = const ['ازرق', 'احمر', 'ابيض', 'اصفر'];
  final List<String> _listSize = const ['S', 'L', 'X', 'XXl'];
  final List<String> _listCity = const ['الناصرة', 'القدس', 'خليل'];

  bool _isChecked = false;
  bool isLiked = false;
  final _formKey = GlobalKey<FormState>();

  final ProductService _productService = Get.find<ProductService>();
  late Future<Product?> _future;

  final PageController _pageController = PageController();
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void toggleLike() {
    setState(() => isLiked = !isLiked);
  }

  Future<Product?> _load() async {
    final args = Get.arguments;

    if (args is Product) return args;

    if (args is Map) {
      final maybeProduct = args['product'];
      if (maybeProduct is Product) return maybeProduct;

      final pid = (args['id'] ?? args['productId'] ?? '').toString().trim();
      if (pid.isNotEmpty) {
        final p = await _productService.fetchProductById(
          productId: pid,
          withLoading: false,
        );
        return p;
      }
    }

    return null;
  }

  List<String> _collectImages(Product product) {
    final out = <String>[];

    void addOne(dynamic v) {
      final s = (v ?? '').toString().trim();
      if (s.isNotEmpty) out.add(s);
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

    addOne(product.coverUrl);
    addOne(product.cover);

    try {
      final dynamic imagesAny = (product as dynamic).images;
      addMany(imagesAny);
    } catch (_) {}

    return out.toSet().toList();
  }

  String _toUrl(String path) {
    final p = path.trim();
    if (p.isEmpty) return '';

    if (p.startsWith('http://') || p.startsWith('https://')) return p;

    final clean = p.startsWith('/') ? p.substring(1) : p;
    const base = 'https://aatene.dev/storage/';
    return '$base$clean';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<Product?>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: getMedium(),
                  ),
                ),
              );
            }

            final product = snapshot.data;

            if (product == null) {
              return Container(
                child: Text('Product not found', style: getMedium()),
              );
            }

            final images = _collectImages(product);
            final title =
                (product.name ?? product.slug ?? '').toString().trim();
            final desc = (product.description ?? product.shortDescription ?? '')
                .toString()
                .trim();
            final price = (product.price ?? '').toString().trim();

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
                                  final url = _toUrl(images[i]);
                                  return Image.network(
                                    url,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    height: 400,
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
                              horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${images.isEmpty ? 0 : images.length}/',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                '${images.isEmpty ? 0 : (_pageIndex + 1)}',
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
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.light1000,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.star,
                                    color: Colors.amberAccent),
                                const Text("5.0"),
                                const Text("(00)"),
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
                          title.isNotEmpty
                              ? title
                              : (isRTL ? 'منتج' : 'Product'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(Icons.location_on_outlined),
                            Text("الجليل . فلسطين "),
                          ],
                        ),
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

                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: CustomDropdown<String>.multiSelect(
                                hintText: 'اختر المقاس',
                                decoration: CustomDropdownDecoration(
                                  hintStyle: getMedium(fontSize: 12),
                                  closedBorderRadius: BorderRadius.circular(10),
                                  closedBorder:
                                      Border.all(color: AppColors.primary100),
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
                            Expanded(
                              child: CustomDropdown<String>.multiSelect(
                                hintText: 'اختر اللون',
                                decoration: CustomDropdownDecoration(
                                  hintStyle: getMedium(fontSize: 12),
                                  closedBorderRadius: BorderRadius.circular(10),
                                  closedBorder:
                                      Border.all(color: AppColors.primary100),
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

                        Row(
                          children: [
                            const Text(" السعر",
                                style: TextStyle(fontSize: 13)),
                            Text(
                              price.isNotEmpty ? " $price ₪" : " -",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

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
                          spacing: 10,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: toggleLike,
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
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 30,
                                        color: isLiked
                                            ? AppColors.error200
                                            : AppColors.neutral300,
                                      ),
                                      Text(
                                        "اعجبني",
                                        style: TextStyle(
                                            color: AppColors.neutral400),
                                      ),
                                    ],
                                  ),
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
                                      style: TextStyle(
                                          color: AppColors.neutral400),
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
                                      style: TextStyle(
                                          color: AppColors.neutral400),
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
                                      style: TextStyle(
                                          color: AppColors.neutral400),
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
                              const Text("معلومات التوصيل"),
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
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/svg_images/car.svg",
                                          width: 28,
                                          height: 28,
                                          color: AppColors.neutral500,
                                        ),
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
                                Row(
                                  spacing: 10,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(15),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/images/svg_images/delivery-truck-svgrepo-com (1) 1.svg",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    const Text(
                                      "التوصيل إلى: ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                          closedBorderRadius:
                                              BorderRadius.circular(10),
                                          closedBorder: Border.all(
                                            color: AppColors.primary100,
                                          ),
                                          closedSuffixIcon: Icon(
                                            Icons
                                                .keyboard_arrow_down_outlined,
                                            color: AppColors.primary400,
                                          ),
                                        ),
                                        initialItem: _listCity[0],
                                        onChanged: (value) {},
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border:
                                        Border.all(color: AppColors.primary50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary400,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: SvgPicture.asset(
                                            "assets/images/svg_images/city_delevery.svg",
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
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

                        ExpansionTile(
                          maintainState: true,
                          title: Row(
                            spacing: 10,
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
                                  "assets/images/svg_images/bag-2.svg",
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                              const Text("عروض"),
                            ],
                          ),
                          children: const [],
                        ),

                        ExpansionTile(
                          maintainState: true,
                          title: Row(
                            spacing: 10,
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
                              const Text("معلومات عن التاجر"),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GestureDetector(
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const CircleAvatar(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "محمد علي",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: AppColors.primary400,
                                                    size: 15,
                                                  ),
                                                  Text(
                                                    "فلسطين, الخليل",
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.primary400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
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
                                                spacing: 5,
                                                children: [
                                                  Icon(
                                                    Icons.person_add_alt,
                                                    color: AppColors.light1000,
                                                    size: 15,
                                                  ),
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
                                            children: const [
                                              Text("عضو منذ "),
                                              Text(" 19-03-2025 "),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(Icons.star_border_rounded),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text(" تقيم التاجر"),
                                              Text("5.0"),
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
                              const Text("مواصفات المنتج"),
                            ],
                          ),
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                desc.isNotEmpty
                                    ? desc
                                    : "لا توجد مواصفات",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.neutral500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
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
                              const Text("تقييمات ومراجعات"),
                            ],
                          ),
                          children: [
                            Column(
                              spacing: 15,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                RatingSummaryWidget(
                                  rating: 4.2,
                                  totalReviews: 1280,
                                  ratingCount: const [20, 15, 5, 4, 2],
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
                              const Text("العلامات"),
                            ],
                          ),
                          children: [
                            Wrap(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.grey[100],
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Text(
                                              "Muse",
                                              style: TextStyle(fontSize: 12),
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
                              label: const Text('دردش'),
                            ),
                          ),
                        ),
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