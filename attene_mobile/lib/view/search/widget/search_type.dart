import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/search/widget/big_search_filter.dart';

class SearchTypeController extends GetxController {
  final Rx<SearchType> selectedType = SearchType.products.obs;

  // متغير لتخزين context الرئيسي
  BuildContext? _mainContext;

  void setMainContext(BuildContext context) {
    _mainContext = context;
  }

  void selectType(SearchType type) {
    selectedType.value = type;

    // إغلاق الـ bottom sheet الحالي
    Get.back();

    // التحقق من وجود context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_mainContext != null && _mainContext!.mounted) {
        _showFilterBottomSheet(type);
      } else if (Get.context != null && Get.context!.mounted) {
        _showFilterBottomSheet(type);
      }
    });
  }

  void _showFilterBottomSheet(SearchType type) {
    final contextToUse = _mainContext ?? Get.context;

    if (contextToUse != null && contextToUse.mounted) {
      showModalBottomSheet(
        context: contextToUse,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => FilterBottomSheet(searchType: type),
      );
    }
  }
}

class SearchTypeBottomSheet extends StatelessWidget {
  const SearchTypeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchTypeController(), permanent: false);

    // تعيين context الرئيسي
    controller.setMainContext(context);

    return _AnimatedSheet(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'البحث عن طريق',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),

            _RadioItem(
              title: 'منتجات',
              value: SearchType.products,
              controller: controller,
            ),
            _RadioItem(
              title: 'متاجر',
              value: SearchType.stores,
              controller: controller,
            ),
            _RadioItem(
              title: 'خدمات',
              value: SearchType.services,
              controller: controller,
            ),
            _RadioItem(
              title: 'مستخدمين',
              value: SearchType.users,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioItem extends StatelessWidget {
  const _RadioItem({
    required this.title,
    required this.value,
    required this.controller,
  });

  final String title;
  final SearchType value;
  final SearchTypeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        onTap: () => controller.selectType(value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio<SearchType>(
                value: value,
                groupValue: controller.selectedType.value,
                onChanged: (_) => controller.selectType(value),
                activeColor: AppColors.primary400,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(title, style: getBold(fontSize: 14)),
              const Spacer(),
            ],
          ),
        ),
      );
    });
  }
}

class _AnimatedSheet extends StatefulWidget {
  const _AnimatedSheet({required this.child});

  final Widget child;

  @override
  State<_AnimatedSheet> createState() => _AnimatedSheetState();
}

class _AnimatedSheetState extends State<_AnimatedSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
