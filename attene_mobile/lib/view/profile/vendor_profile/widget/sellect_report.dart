import 'package:attene_mobile/component/index.dart';
import 'package:attene_mobile/view/profile/user_profile/screen/user_profile.dart';
import 'package:flutter/material.dart';

import '../../../../utils/index.dart';

class SelectionBottomSheet extends StatefulWidget {
  const SelectionBottomSheet({super.key});

  @override
  State<SelectionBottomSheet> createState() => _SelectionBottomSheetState();
}

class _SelectionBottomSheetState extends State<SelectionBottomSheet> {
  // متغير لتخزين القيمة المختارة
  String? _selectedReason = 'reason_4';

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // شريط السحب العلوي (Handle)
          // Container(
          //   width: 50,
          //   height: 5,
          //   decoration: BoxDecoration(
          //     color: Colors.grey[300],
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          // ),
          // const SizedBox(height: 10),

          // الرقم العلوي
          // const Align(
          //   alignment: Alignment.topLeft,
          //   child: Text(
          //     '30',
          //     style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          //   ),
          // ),

          // العنوان الرئيسي
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "الإبلاغ عن إساءة",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // قائمة الخيارات
          _buildOption(
            id: 'reason_1',
            title: 'محتوى مخالف',
            subtitle: 'يحتوي على سب/إهانة، كلمات نابية، أو إساءة مباشرة.',
          ),
          _buildOption(
            id: 'reason_2',
            title: 'محتوى غير لائق / غير مناسب',
            subtitle: 'يتضمن صور أو نصوص مخالفة للأدب أو الحياء.',
          ),
          _buildOption(
            id: 'reason_3',
            title: 'إعلان أو ترويج غير مناسب',
            subtitle: 'الطلب نفسه عبارة عن دعاية أو سبام.',
          ),
          _buildOption(
            id: 'reason_4',
            title: 'محتوى مضلل / كاذب',
            subtitle: "معلومات غير صحيحة أو طلب غير واقعي.",
          ),
          _buildOption(
            id: 'reason_5',
            title: 'محاولة احتيال / نشاط مشبوه',
            subtitle: "مثل محاولة سرقة بيانات أو استغلال المستخدمين.",
          ),

          const SizedBox(height: 20),

          // زر التأكيد (إلغاء أو تنفيذ)
          AateneButton(
            onTap: () {
              showModalBottomSheet(
                // isScrollControlled: true,
                context: context,
                builder: (context) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // العنوان الرئيسي
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "الإبلاغ عن إساءة",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الموضوع",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFiledAatene(
                              isRTL: isRTL,
                              hintText: "اكتب هنا",
                              textInputAction: TextInputAction.next, textInputType: TextInputType.name,
                            ),
                          ],
                        ),
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الشكوى/ الأفتراح",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextField(
                              textDirection: TextDirection.rtl,
                              keyboardType: TextInputType.text,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: "اكتب هنا",
                                hintTextDirection: TextDirection.rtl,
                                hintStyle: getRegular(
                                  color: AppColors.neutral600,
                                  fontSize: 14,
                                ),
                                border: const UnderlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),

                                  borderSide: BorderSide(
                                    color: AppColors.neutral600,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.neutral900,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  borderSide: BorderSide(
                                    color: AppColors.primary400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        AateneButton(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                height: 300,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      spacing: 15,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green,
                                          size: 80,
                                        ),
                                        Text(
                                          "تم استلام بلاغك بنجاح شكرًا لك على تعاونك.",
                                          textAlign: TextAlign.center,
                                          style: getBlack(fontSize: 18),
                                        ),
                                        AateneButton(
                                          buttonText: "عودة للرئيسية",
                                          color: AppColors.primary400,
                                          borderColor: AppColors.primary400,
                                          textColor: AppColors.light1000,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder: (context) =>
                                                    ProfilePage(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          buttonText: "ارسال",
                          borderColor: AppColors.primary400,
                          color: AppColors.primary400,
                          textColor: AppColors.light1000,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            buttonText: "التالي",
            borderColor: AppColors.primary400,
            color: AppColors.primary400,
            textColor: AppColors.light1000,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // بناء عنصر الخيار الواحد
  Widget _buildOption({
    required String id,
    required String title,
    required String subtitle,
  }) {
    // bool isSelected = _selectedReason == id;

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        // color: isSelected ? Colors.white : Colors.grey[50],
      ),
      child: RadioListTile<String>(
        value: id,
        groupValue: _selectedReason,
        activeColor: AppColors.primary400,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        controlAffinity: ListTileControlAffinity.leading, // الدائرة على اليسار
        onChanged: (value) {
          setState(() {
            _selectedReason = value;
          });
        },
        title: Text(
          title,
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ),
    );
  }
}
