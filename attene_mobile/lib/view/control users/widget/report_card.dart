import '../../../general_index.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.image,
    required this.title,
    required this.screen,
  });

  final Image image;
  final String title;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => screen),
        );
      },
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              image,
              Text(title, style: getBold()),
            ],
          ),
        ),
      ),
    );
  }
}
