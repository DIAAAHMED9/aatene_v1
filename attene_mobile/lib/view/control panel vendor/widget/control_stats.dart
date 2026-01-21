import 'package:attene_mobile/general_index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/vendor_controller.dart';

class DashboardStats extends StatelessWidget {
  final DashboardController controller;

  const DashboardStats({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        _statCard(
          title: 'اجمالي المنتجات',
          value: controller.productsCount,
          icon: SvgPicture.asset(
            'assets/images/svg_images/shirt.svg',
            semanticsLabel: 'My SVG Image',
            height: 28,
            width: 28,
          ),
          color: Colors.purple,
        ),
        _statCard(
          title: 'الاضافة للمفضلة',
          value: controller.favoritesCount,
          icon: Icon(Icons.favorite_border_sharp, color: AppColors.primary400,size: 30,),
          color: AppColors.primary400,

        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required RxInt value,
    required Widget icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            Text(title, style: getBold(fontSize: 18,)),
            Spacer(),
            Obx(
              () => Text(
                value.value.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
