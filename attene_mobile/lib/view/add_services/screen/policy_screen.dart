

import '../../../general_index.dart';
import '../../../utils/responsive/responsive_dimensions.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildCopyrightSection(),
            _buildTermsSection(),
            _buildPrivacySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(16),
        vertical: ResponsiveDimensions.responsiveHeight(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الشروط والخصوصية',
            style: getBold(
              fontSize: ResponsiveDimensions.responsiveFontSize(24),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
          Text(
            'يرجى قراءة وموافقة على جميع السياسات التالية قبل نشر الخدمة',
            style: getRegular(
              fontSize: ResponsiveDimensions.responsiveFontSize(14),
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyrightSection() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(16),
        vertical: ResponsiveDimensions.responsiveHeight(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إشعار حقوق النشر',
            style: getBold(
              fontSize: ResponsiveDimensions.responsiveFontSize(18),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),

          Text(
            'بإرسال خدمتك، تُقرّ بملكيتك أو حقوقك في المواد المنشورة، وأن نشر هذه المواد لا ينتهك حقوق أي طرف ثالث. كما تُقرّ بفهمك أن مشروعك سيخضع للمراجعة والتقييم من قِبل المنصة لضمان استيفائه للمتطلبات.',
            style: getRegular(
              fontSize: ResponsiveDimensions.responsiveFontSize(14),
              color: Color(0xFF424242),
            ),
            textAlign: TextAlign.right,
          ),

          SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return Padding(
      padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'شروط الخدمة',
            style: getBold(
              fontSize: ResponsiveDimensions.responsiveFontSize(18),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),

          Text(
            'يوافق المستخدم على شروط استخدام المنصة بما في ذلك الالتزام بمعايير الجودة والاستجابة للعملاء في الأوقات المحددة. يحق للمنصة إزالة أي خدمة تنتهك الشروط دون سابق إنذار.',
            style: getRegular(
              fontSize: ResponsiveDimensions.responsiveFontSize(14),
              color: Color(0xFF424242),
            ),
            textAlign: TextAlign.right,
          ),

          SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),

          GetBuilder<ServiceController>(
            id: 'terms_section',
            builder: (controller) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: controller.acceptedTerms.value,
                    onChanged: (value) {
                      controller.updateTermsAcceptance(value ?? false);
                    },
                    activeColor: AppColors.primary400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أفهم وأوافق على شروط خدمة المنصة، بما في ذلك اتفاقية المستخدم',
                          style: TextStyle(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              14,
                            ),
                            color: Colors.grey[800],
                            fontFamily: "PingAR",
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveDimensions.responsiveHeight(4),
                        ),
                        InkWell(
                          onTap: () {
                            // Get.snackbar(
                            //   'شروط الخدمة',
                            //   'سيتم فتح صفحة شروط الخدمة قريباً',
                            //   backgroundColor: Colors.blue,
                            //   colorText: Colors.white,
                            // );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveDimensions.responsiveHeight(
                                4,
                              ),
                            ),
                            child: Text(
                              'اتفاقية المستخدم وسياسة الخصوصية',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveDimensions.responsiveFontSize(14),
                                color: AppColors.primary400,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                fontFamily: "PingAR",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Padding(
      padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إشعار الخصوصية',
            style: getBold(
              fontSize: ResponsiveDimensions.responsiveFontSize(18),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),

          Text(
            'ستكون الخدمة مرئية للعامة في نتائج البحث. سيتم جمع ومعالجة البيانات المقدمة وفقًا لسياسة الخصوصية. يتحمل المستخدم المسؤولية الكاملة عن أي معلومات شخصية يشاركها في وصف الخدمة.',
            style: getRegular(
              fontSize: ResponsiveDimensions.responsiveFontSize(14),
              color: Color(0xFF424242),
            ),
            textAlign: TextAlign.right,
          ),

          SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),

          GetBuilder<ServiceController>(
            id: 'privacy_section',
            builder: (controller) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: controller.acceptedPrivacy.value,
                    onChanged: (value) {
                      controller.updatePrivacyAcceptance(value ?? false);
                    },
                    activeColor: AppColors.primary400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'من خلال إرسال هذه الخدمة وتفعيلها، أفهم أنها ستظهر في نتائج البحث للعامة وستكون مرئية للمستخدمين الآخرين.',
                          style: TextStyle(
                            fontFamily: "PingAR",
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              14,
                            ),
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveDimensions.responsiveHeight(4),
                        ),
                        InkWell(
                          onTap: () {
                            Get.snackbar(
                              'سياسة الخصوصية',
                              'سيتم فتح صفحة سياسة الخصوصية قريباً',
                              backgroundColor: Colors.blue,
                              colorText: Colors.white,
                            );
                          },
                          child: Text(
                            'قراءة سياسة الخصوصية الكاملة',
                            style: TextStyle(
                              fontSize: ResponsiveDimensions.responsiveFontSize(
                                14,
                              ),
                              color: AppColors.primary400,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              fontFamily: "PingAR",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(16),
        vertical: ResponsiveDimensions.responsiveHeight(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<ServiceController>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
                  _buildPolicyStatus(
                    'شروط الخدمة',
                    controller.acceptedTerms.value,
                  ),
                  SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
                  _buildPolicyStatus(
                    'سياسة الخصوصية',
                    controller.acceptedPrivacy.value,
                  ),
                  SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveDimensions.responsiveWidth(12),
                    ),
                    decoration: BoxDecoration(
                      color: controller.allPoliciesAccepted
                          ? Colors.green[50]
                          : Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: controller.allPoliciesAccepted
                            ? Colors.green[200]!
                            : Colors.orange[200]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          controller.allPoliciesAccepted
                              ? Icons.check_circle
                              : Icons.warning,
                          color: controller.allPoliciesAccepted
                              ? Colors.green
                              : Colors.orange,
                          size: ResponsiveDimensions.responsiveFontSize(20),
                        ),
                        SizedBox(
                          width: ResponsiveDimensions.responsiveWidth(8),
                        ),
                        Expanded(
                          child: Text(
                            controller.allPoliciesAccepted
                                ? '✓ جميع السياسات موافق عليها - يمكنك نشر الخدمة'
                                : 'لم تتم الموافقة على جميع السياسات بعد',
                            style: TextStyle(
                              fontSize: ResponsiveDimensions.responsiveFontSize(
                                14,
                              ),
                              color: controller.allPoliciesAccepted
                                  ? Colors.green[800]
                                  : Colors.orange[800],
                              fontWeight: FontWeight.w500,
                              fontFamily: "PingAR",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
          Container(
            padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(12)),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary100),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primary500,
                  size: ResponsiveDimensions.responsiveFontSize(20),
                ),
                SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                Expanded(
                  child: Text(
                    'يجب الموافقة على جميع السياسات الثلاثة قبل نشر الخدمة',
                    style: getRegular(
                      fontSize: ResponsiveDimensions.responsiveFontSize(13),
                      color: AppColors.primary500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyStatus(String title, bool isAccepted) {
    return Row(
      children: [
        Icon(
          isAccepted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isAccepted ? Colors.green : Colors.grey,
          size: ResponsiveDimensions.responsiveFontSize(16),
        ),
        SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
        Text(
          title,
          style: getRegular(
            fontSize: ResponsiveDimensions.responsiveFontSize(14),
            color: isAccepted ? Colors.green : Colors.grey,
            fontWeight: isAccepted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
