import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/aatene_button/aatene_button.dart';
import '../../utlis/colors/app_color.dart';
import '../../utlis/image flip/image_utils.dart';
import '../../utlis/language/language_utils.dart';

class Onbording extends StatelessWidget {
  const Onbording({super.key});

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
          style: TextStyle(
            fontSize: ResponsiveDimensions.getFontSize(context, baseSize: 16),
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
      leading: Icon(
        icon,
        color: isCurrentLang ? Colors.blue : Colors.grey,
        size: ResponsiveDimensions.getIconSize(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: ResponsiveDimensions.getFontSize(context, baseSize: 14),
          fontWeight: isCurrentLang ? FontWeight.bold : FontWeight.normal,
          color: isCurrentLang ? Colors.blue : Colors.black,
        ),
      ),
      trailing: isCurrentLang
          ? Icon(Icons.check_circle, color: Colors.blue)
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              return _buildResponsiveContent(context, constraints);
            },
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              bottom: ResponsiveDimensions.h(40),
              left: ResponsiveDimensions.getContentPadding(context).horizontal,
              right: ResponsiveDimensions.getContentPadding(context).horizontal,
            ),
            child: Container(
              height: ResponsiveDimensions.getButtonHeight(context),
              child: AateneButton(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/start_login');
                },
                buttonText: isRTL ? 'ابدأ' : 'Start',
                textColor: AppColors.light1000,
                color: AppColors.primary400,
                borderColor: AppColors.primary400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveContent(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final isRTL = LanguageUtils.isRTL;
    final isMobile = ResponsiveDimensions.isMobile;
    final isTablet = ResponsiveDimensions.isTablet;
    final isLaptop = ResponsiveDimensions.isLaptop;

    return Column(
      children: [
        // Language Selector Row
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.getContentPadding(
              context,
            ).horizontal,
            vertical: ResponsiveDimensions.h(isMobile ? 10 : 20),
          ),
          child: Row(
            mainAxisAlignment: isMobile
                ? MainAxisAlignment.center
                : MainAxisAlignment.end,
            children: [
              Text(
                isRTL ? 'اللغة: العربية' : 'Language: English',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.getFontSize(
                    context,
                    baseSize: 14,
                  ),
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showLanguageDialog(context),
                child: Text(
                  isRTL ? 'تغيير' : 'Change',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.getFontSize(
                      context,
                      baseSize: 14,
                    ),
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: _buildMainContent(
            context,
            isRTL,
            isMobile,
            isTablet,
            isLaptop,
          ),
        ),

        // Description Text
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.getContentPadding(
              context,
            ).horizontal,
            vertical: ResponsiveDimensions.h(20),
          ),
          margin: EdgeInsets.only(bottom: ResponsiveDimensions.h(20)),
          child: Text(
            isRTL
                ? 'اعطيني هو أفضل تطبيق تسوق عبر الإنترنت لأزياء رائدة محلياً توفر مجموعة كبيرة ومتنوعة من المنتجات، لحياة أسهل تتماشى مع نمط حياتنا السريع والمتغير وبأسعار بمتناول الجميع.'
                : 'Atene is the best online shopping app for locally leading fashion, offering a wide and diverse range of products for an easier life that aligns with our fast-paced and changing lifestyle at affordable prices for everyone.',
            style: TextStyle(
              fontSize: ResponsiveDimensions.getFontSize(context, baseSize: 14),
              color: Colors.black,
              height: 1.5,
              fontWeight: FontWeight.w300,
            ),
            textAlign: isMobile ? TextAlign.start : TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    bool isRTL,
    bool isMobile,
    bool isTablet,
    bool isLaptop,
  ) {
    if (isLaptop) {
      return _buildLaptopLayout(context, isRTL);
    } else if (isTablet) {
      return _buildTabletLayout(context, isRTL);
    } else {
      return _buildMobileLayout(context, isRTL);
    }
  }

  Widget _buildMobileLayout(BuildContext context, bool isRTL) {
    return Image.asset(
      'assets/images/png/onboarding.png',
      width: double.infinity,
      height: ResponsiveDimensions.h(400),
    );
  }

  Widget _buildTabletLayout(BuildContext context, bool isRTL) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isRTL) ...[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: ResponsiveDimensions.w(40)),
              child: _buildTextContent(context, isRTL, true),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/png/onboarding_child.png',
                width: ResponsiveDimensions.w(300),
                height: ResponsiveDimensions.h(300),
              ),
            ),
          ),
        ],
        if (isRTL) ...[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/png/onboarding_child.png',
                width: ResponsiveDimensions.w(300),
                height: ResponsiveDimensions.h(300),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: ResponsiveDimensions.w(40)),
              child: _buildTextContent(context, isRTL, true),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLaptopLayout(BuildContext context, bool isRTL) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isRTL) ...[
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: ResponsiveDimensions.w(60)),
              child: _buildTextContent(context, isRTL, false),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/png/onboarding_child.png',
                width: ResponsiveDimensions.w(400),
                height: ResponsiveDimensions.h(400),
              ),
            ),
          ),
        ],
        if (isRTL) ...[
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/png/onboarding_child.png',
                width: ResponsiveDimensions.w(400),
                height: ResponsiveDimensions.h(400),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(right: ResponsiveDimensions.w(60)),
              child: _buildTextContent(context, isRTL, false),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextContent(BuildContext context, bool isRTL, bool isTablet) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isRTL
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/png/aatene_black_text.png',
          width: isTablet
              ? ResponsiveDimensions.w(150)
              : ResponsiveDimensions.w(180),
          height: isTablet
              ? ResponsiveDimensions.h(60)
              : ResponsiveDimensions.h(70),
        ),
        SizedBox(height: ResponsiveDimensions.h(30)),
        Text.rich(
          TextSpan(
            text: isRTL
                ? 'مزيج من الخدمات المتنوعة متواجدة في مكان '
                : 'A mix of diverse services available in one ',
            style: TextStyle(
              fontSize: isTablet
                  ? ResponsiveDimensions.getFontSize(context, baseSize: 40)
                  : ResponsiveDimensions.getFontSize(context, baseSize: 48),
              fontWeight: FontWeight.w800,
              color: const Color(0xFF383838),
              height: 1.4,
            ),
            children: [
              TextSpan(
                text: isRTL ? 'واحد' : 'place',
                style: TextStyle(
                  fontSize: isTablet
                      ? ResponsiveDimensions.getFontSize(context, baseSize: 40)
                      : ResponsiveDimensions.getFontSize(context, baseSize: 48),
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary400,
                ),
              ),
            ],
          ),
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }
}
