import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utlis/language/language_utils.dart';
import '../controller/followers_controller.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    final controller = Get.find<FollowersController>();

    return TextFiledAatene(
      isRTL: isRTL,
      hintText: "بحث",
      textInputAction: TextInputAction.done,
      filled: true,
      onChanged: controller.onSearch,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 2,top: 2),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.primary300,
            ),

            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(Icons.search, color: Colors.white,size: 25,),
            )),
      ),
    );

  }
}
