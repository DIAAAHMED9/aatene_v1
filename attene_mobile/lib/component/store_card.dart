import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/view/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import '../utils/colors/app_color.dart';
import '../view/profile/vendor_profile/screen/store_profile.dart';

class VendorCard extends StatelessWidget {
  const VendorCard({super.key, });


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return GestureDetector(
      onTap: () {
        Get.to(StoreProfilePage());
      },
      child: Container(
        width: 162,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral900, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/images/png/ser1.png',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'إعلان ممول',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 5,
                  child: Obx(() {
                    final isFollowed = controller.service.value.isFollowed;

                    return GestureDetector(
                      onTap: controller.toggleFollow,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          /// تغيير اللون حسب الحالة
                          color: isFollowed
                              ? AppColors.primary100
                              : AppColors.primary400,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),

                        /// تغيير الأيقونة حسب الحالة
                        child: Icon(
                          isFollowed
                              ? Icons.arrow_forward
                              : Icons.person_add_alt,
                          color: isFollowed
                              ? AppColors.primary400
                              : Colors.white,
                          size: 22,
                        ),
                      ),
                    );
                  }),
                ),

                // Positioned(
                //   bottom: -15,
                //   left: 10,
                //   // top: 2,
                //   child: CircleAvatar(
                //     radius: 18,
                //     backgroundColor: AppColors.primary400,
                //     child: const Icon(
                //       Icons.person_add_alt,
                //       color: Colors.white,
                //       size: 22,
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 26),
            const Text(
              '👑 EtnixByron ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              spacing: 7,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.stars_rounded, size: 16, color: Colors.orange),
                Text(
                  '5.0',
                  style: TextStyle(fontSize: 12, color: AppColors.neutral400),
                ),
                Icon(
                  Icons.local_shipping_outlined,
                  size: 16,
                  color: AppColors.success300,
                ),
                Icon(Icons.shield_moon_outlined, size: 16, color: Colors.teal),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
