import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/followers_controller.dart';
import '../models/follower_model.dart';

class UnfollowDialog extends StatelessWidget {
  final FollowerModel model;

  const UnfollowDialog({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowersController>();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title:  Text(
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
        TextButton(
          onPressed: () => Get.back(),
          child:  Text('إلغاء',style: getMedium(color: AppColors.primary400),),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          onPressed: () {
            Get.back();
            controller.unfollow(model);
          },
          child:  Text('تأكيد',style: getMedium(color: Colors.white),),
        ),
      ],
    );
  }
}
