import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/aatene_button.dart';
import '../../utlis/colors/app_color.dart';
import '../../utlis/image_flip/image_utils.dart';
import '../../utlis/language/language_utils.dart';
class Onbording extends StatelessWidget {
  const Onbording({super.key});
  void _changeLanguage(String languageCode, String countryCode) {
    Get.updateLocale(Locale(languageCode, countryCode));
  }
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'اختر اللغة / Choose Language',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLanguageOption(
                  context,
                  'العربية',
                  'ar',
                  'SA',
                  Icons.language,
                ),
                const SizedBox(height: 12),
                _buildLanguageOption(
                  context,
                  'English',
                  'en',
                  'US',
                  Icons.language,
                ),
              ],
            ),
          ),
    );
  }
  Widget _buildLanguageOption(
    BuildContext context,
    String title,
    String languageCode,
    String countryCode,
    IconData icon,
  ) {
    final isCurrentLang = Get.locale?.languageCode == languageCode;
    return ListTile(
      leading: Icon(icon, color: isCurrentLang ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isCurrentLang ? FontWeight.bold : FontWeight.normal,
          color: isCurrentLang ? Colors.blue : Colors.black,
        ),
      ),
      trailing:
          isCurrentLang
              ? const Icon(Icons.check_circle, color: Colors.blue)
              : null,
      onTap: () {
        _changeLanguage(languageCode, countryCode);
        Navigator.of(context).pop();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isCurrentLang ? Colors.blue : Colors.grey.shade300,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isRTL ? 'اللغة: العربية' : 'Language: English',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.f(5),
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showLanguageDialog(context),
                    child: Text(
                      isRTL ? 'تغيير' : 'Change',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.f(5),
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: ResponsiveDimensions.h(40),
                      left: isRTL ? 0 : null, 
                      right: isRTL ? null : 0, 
                      child:
                          isRTL
                              ? Image.asset(
                                'assets/images/png/onboarding_child.png',
                              )
                              : ImageUtils.flipHorizontal(
                                'assets/images/png/onboarding_child.png',
                              ),
                    ),
                    Positioned(
                      top: ResponsiveDimensions.h(77),
                      left: isRTL ? null : ResponsiveDimensions.w(20),
                      right: isRTL ? ResponsiveDimensions.w(20) : null,
                      child: SizedBox(
                        width:
                            isRTL
                                ? ResponsiveDimensions.w(180)
                                : ResponsiveDimensions.w(215),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment:
                                  isRTL
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Image.asset(
                                'assets/images/png/aatene_black_text.png',
                                width: ResponsiveDimensions.w(120),
                                height: ResponsiveDimensions.h(50),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text.rich(
                              TextSpan(
                                text:
                                    isRTL
                                        ? 'مزيج من الخدمات المتنوعة متواجدة في مكان '
                                        : 'A mix of diverse services available in one ',
                                style: TextStyle(
                                  fontSize: ResponsiveDimensions.f(45),
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF383838),
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: isRTL ? 'واحد' : 'place',
                                    style: TextStyle(
                                      fontSize: ResponsiveDimensions.f(45),
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary400,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign:
                                  isRTL ? TextAlign.right : TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveDimensions.w(20),
                  vertical: ResponsiveDimensions.h(20),
                ),
                margin: EdgeInsets.only(bottom: ResponsiveDimensions.h(30)),
                child: Text(
                  isRTL
                      ? 'اعطيني هو أفضل تطبيق تسوق عبر الإنترنت لأزياء رائدة محلياً توفر مجموعة كبيرة ومتنوعة من المنتجات، لحياة أسهل تتماشى مع نمط حياتنا السريع والمتغير وبأسعار بمتناول الجميع.'
                      : 'Atene is the best online shopping app for locally leading fashion, offering a wide and diverse range of products for an easier life that aligns with our fast-paced and changing lifestyle at affordable prices for everyone.',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(12),
                    color: Colors.grey[700],
                    height: 1.5,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          bottomNavigationBar: AateneButton(onTap: () {
            Navigator.pushReplacementNamed(context, '/start_login');
          }, buttonText: isRTL ? 'ابدأ' : 'Start',
          color: AppColors.primary400,
          borderColor: AppColors.primary400
          ),
      ),
    ),);
  }
}
