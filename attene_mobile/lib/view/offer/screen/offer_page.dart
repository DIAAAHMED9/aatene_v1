// import 'package:attene_mobile/general_index.dart';
//
// class FlashSalePage extends StatefulWidget {
//   const FlashSalePage({super.key});
//
//   @override
//   State<FlashSalePage> createState() => _FlashSalePageState();
// }
//
// class _FlashSalePageState extends State<FlashSalePage> {
//   final PageController _pageController = PageController();
//   int selectedIndex = 1;
//
//   final List<String> tabs = ["الجميع", "10%", "20%", "30%", "40%", "50%"];
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         // backgroundColor: const Color(0xFFF6F6F6),
//         body: Column(
//           children: [
//             const FlashHeader(),
//             const SizedBox(height: 12),
//             DiscountTabs(
//               tabs: tabs,
//               selectedIndex: selectedIndex,
//               onTap: (index) {
//                 setState(() => selectedIndex = index);
//                 _pageController.animateToPage(
//                   index,
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                 );
//               },
//             ),
//             const SizedBox(height: 12),
//             // Expanded(
//             //   child: ProductsPageView(
//             //     controller: _pageController,
//             //     onPageChanged: (index) {
//             //       setState(() => selectedIndex = index);
//             //     },
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /* ================= HEADER ================= */
//
// class FlashHeader extends StatelessWidget {
//   const FlashHeader({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 220,
//       child: Stack(
//         children: [
//           Positioned.fill(
//             right: 0,
//             top: 0,
//             child: Image.asset(
//               "assets/images/png/Bubbles.png",
//               width: double.infinity,
//             ),
//           ),
//           // Positioned.fill(
//           //   child: ClipPath(
//           //     clipper: _HeaderClipper(),
//           //     child: Container(
//           //       decoration: const BoxDecoration(
//           //         gradient: LinearGradient(
//           //           colors: [Color(0xFF0A57FF), Color(0xFF1E6BFF)],
//           //           begin: Alignment.topRight,
//           //           end: Alignment.bottomLeft,
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const _TimeBox(value: "58"),
//                     const _TimeBox(value: "36"),
//                     const _TimeBox(value: "00"),
//                     const SizedBox(width: 8),
//                     const Icon(Icons.timer_outlined, color: Colors.white),
//                     const Spacer(),
//                     Column(
//                       children: [
//                         Text("بيع فلاش", style: getBold(fontSize: 28)),
//                         const SizedBox(height: 6),
//                         Text("اختر الخصم الخاص بك", style: getMedium()),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _TimeBox extends StatelessWidget {
//   final String value;
//
//   const _TimeBox({required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(value, style: getBold(fontSize: 18)),
//     );
//   }
// }
//
// /* ================= DISCOUNT TABS ================= */
//
// class DiscountTabs extends StatelessWidget {
//   final List<String> tabs;
//   final int selectedIndex;
//   final ValueChanged<int> onTap;
//
//   const DiscountTabs({
//     super.key,
//     required this.tabs,
//     required this.selectedIndex,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 48,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         color: Color(0xFFF6F6F6),
//         borderRadius: BorderRadius.circular(24),
//       ),
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: tabs.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 6),
//         itemBuilder: (context, index) {
//           final isSelected = index == selectedIndex;
//           return GestureDetector(
//             onTap: () => onTap(index),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 18),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.white : Colors.transparent,
//                 borderRadius: BorderRadius.circular(20),
//                 border: isSelected
//                     ? Border.all(color: AppColors.primary400, width: 3)
//                     : null,
//               ),
//               child: Text(
//                 tabs[index],
//                 style: getBold(
//                   color: isSelected ? AppColors.primary400 : Colors.black,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// /* ================= PAGE VIEW ================= */
//
// class ProductsPageView extends StatelessWidget {
//   final PageController controller;
//   final ValueChanged<int> onPageChanged;
//
//   const ProductsPageView({
//     super.key,
//     required this.controller,
//     required this.onPageChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return PageView.builder(
//       controller: controller,
//       onPageChanged: onPageChanged,
//       itemCount: 6,
//       itemBuilder: (_, _) {
//         return GridView.builder(
//           padding: const EdgeInsets.all(16),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             mainAxisSpacing: 16,
//             crossAxisSpacing: 16,
//             childAspectRatio: 0.62,
//           ),
//           itemCount: 6,
//           itemBuilder: (_, __) => const ProductCard(),
//         );
//       },
//     );
//   }
// }
//
// /* ================= PRODUCT CARD ================= */
//
// class ProductCard extends StatelessWidget {
//   const ProductCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(16),
//                   ),
//                   child: Image.network(
//                     "https://i.imgur.com/QCNbOAo.png",
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                   ),
//                 ),
//                 Positioned(top: 8, right: 8, child: _DiscountBadge()),
//               ],
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "تي شيرت الأنجار",
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Text(
//                       "21 دولار",
//                       style: TextStyle(
//                         decoration: TextDecoration.lineThrough,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     SizedBox(width: 6),
//                     Text(
//                       "14 دولار",
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _DiscountBadge extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.red,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: const Text(
//         "-20%",
//         style: TextStyle(color: Colors.white, fontSize: 12),
//       ),
//     );
//   }
// }
//
// /* ================= CLIPPER ================= */
//
// class _HeaderClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(0, size.height - 40);
//     path.quadraticBezierTo(
//       size.width * 0.4,
//       size.height,
//       size.width,
//       size.height - 80,
//     );
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }
// lib/views/flash_sale/flash_sale_view.dart
import 'package:attene_mobile/general_index.dart';
import '../flash_sale_controller.dart';
import '../widget/discount_tabs.dart';
import '../widget/flash_header.dart';
import '../widget/products_page_view.dart';

/// الشاشة الرئيسية للعروض الترويجية (Flash Sale)
class FlashSaleView extends StatelessWidget {
  FlashSaleView({super.key});

  // ربط الـ Controller مع GetX
  final FlashSaleController controller = Get.put(FlashSaleController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            const FlashHeader(), // رأس الصفحة
            const SizedBox(height: 12),

            // تبويبات الخصم - تستجيب لتغيرات الـ Controller
            Obx(
              () => DiscountTabs(
                tabs: controller.tabs,
                selectedIndex: controller.selectedIndex,
                onTap: controller.changeTab,
              ),
            ),

            const SizedBox(height: 12),

            // منطقة المنتجات - PageView
            Expanded(
              child: ProductsPageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
