import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:attene_mobile/utils/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/aatene_button/aatene_button.dart';
import '../controller/followers_controller.dart';
import '../models/follower_model.dart';

class UnfollowDialog extends StatelessWidget {
  final FollowerModel model;

  const UnfollowDialog({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowersController>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'تأكيد إلغاء المتابعة',
        textAlign: TextAlign.right,
        style: getBold(fontSize: 18),
      ),
      content: Text(
        'هل أنت متأكد من إلغاء متابعة ${model.name}؟',
        textAlign: TextAlign.right,
        style: getBold(),
      ),
      actions: [
        AateneButton(
          onTap: () {
            Get.back();
            controller.unfollow(model);
          },
          buttonText: "تأكيد",
          color: AppColors.primary400,
          textColor: AppColors.light1000,
          borderColor: AppColors.primary400,
        ),
        SizedBox(height: 10),
        AateneButton(
          onTap: () => Get.back(),
          buttonText: "إلغاء",
          color: AppColors.light1000,
          textColor: AppColors.primary400,
          borderColor: AppColors.primary400,
        ),
      ],
    );
  }
}
