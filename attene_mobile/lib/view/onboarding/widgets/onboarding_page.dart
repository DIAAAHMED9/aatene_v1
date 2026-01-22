import '../../../general_index.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            /// النصوص
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.60),

                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: getBlack(fontSize: 24, color: AppColors.primary400),
                ).animate().fadeIn(duration: 500.ms),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: getMedium(color: AppColors.primary400),
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ],
            ),
            /// صورة
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                data.svg,
                height: 200,
                fit: BoxFit.contain,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
            ),
          ],
        ),
      ],
    );
  }
}
