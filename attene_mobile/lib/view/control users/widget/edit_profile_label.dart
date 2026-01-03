import '../../../general_index.dart';

class EditProfileLabel extends StatelessWidget {
  const EditProfileLabel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.screen,
  });

  final String title;
  final String subtitle;
  final Widget icon;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.neutral1000,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 12, left: 12),
          child: Row(
            spacing: 12,
            children: [
              icon,
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: getMedium(fontSize: 14)),
                    Text(
                      subtitle,
                      style: getRegular(
                        fontSize: 12,
                        color: AppColors.neutral300,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: AppColors.neutral50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
