import '../../../general_index.dart';
import '../../../utils/image_flip/index.dart';
import '../../../utils/responsive/index.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  void _changeLanguage(String languageCode, String countryCode) {
    Get.updateLocale(Locale(languageCode, countryCode));
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'اختر اللغة / Choose Language',
          textAlign: TextAlign.center,
          style: getBold(fontSize: ResponsiveDimensions.f(18)),
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
        style: getRegular(
          fontWeight: isCurrentLang ? FontWeight.bold : FontWeight.normal,
          color: isCurrentLang ? Colors.blue : Colors.black,
        ),
      ),
      trailing: isCurrentLang
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
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: ResponsiveDimensions.h(40),
                      left: isRTL ? 0 : null,
                      right: isRTL ? null : 0,
                      child: isRTL
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
                        width: isRTL
                            ? ResponsiveDimensions.w(180)
                            : ResponsiveDimensions.w(215),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: isRTL
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
                                text: isRTL
                                    ? 'مزيج من الخدمات المتنوعة متواجدة في مكان '
                                    : 'A mix of diverse services available in one ',
                                style: getBlack(
                                  fontSize: ResponsiveDimensions.f(39),
                                ),
                                children: [
                                  TextSpan(
                                    text: isRTL ? 'واحد' : 'place',
                                    style: getBlack(
                                      fontSize: ResponsiveDimensions.f(35),
                                      color: AppColors.primary400,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: isRTL
                                  ? TextAlign.right
                                  : TextAlign.left,
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
                  style: getRegular(
                    fontWeight: FontWeight.w300,
                    fontSize: ResponsiveDimensions.f(14),
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: AateneButton(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/start_login');
              },
              buttonText: isRTL ? 'ابدأ الان' : 'Start Now',
              textColor: AppColors.light1000,
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
            ),
          ),
        ),
      ),
    );
  }
}
