import 'package:attene_mobile/general_index.dart';


/// ================= ENUM =================
enum SearchType { products, stores, services, users }

/// ================= CONTROLLER =================
class SearchTypeController extends GetxController {
  final Rx<SearchType> selectedType = SearchType.products.obs;

  void selectType(SearchType type) {
    selectedType.value = type;
    Get.back(result: type); // إغلاق + إرجاع القيمة
  }
}

/// ================= BOTTOM SHEET =================
class SearchTypeBottomSheet extends StatelessWidget {
  const SearchTypeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchTypeController());

    return _AnimatedSheet(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Indicator
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            /// Title
            Center(
              child: const Text(
                textAlign: TextAlign.center,
                'البحث عن طريق',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 24),

            const _RadioItem(title: 'منتجات', value: SearchType.products),
            const _RadioItem(title: 'متاجر', value: SearchType.stores),
            const _RadioItem(title: 'خدمات', value: SearchType.services),
            const _RadioItem(title: 'مستخدمين', value: SearchType.users),
          ],
        ),
      ),
    );
  }
}

/// ================= RADIO ITEM =================
class _RadioItem extends GetView<SearchTypeController> {
  const _RadioItem({required this.title, required this.value});

  final String title;
  final SearchType value;

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
              Text(title, style: getMedium(fontSize: 14)),
              Spacer()
            ],
          ),
        ),
      );
    });
  }
}

/// ================= ANIMATION (Fade + Slide) =================
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
