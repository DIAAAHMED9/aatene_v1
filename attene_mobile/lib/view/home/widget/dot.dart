import '../../../general_index.dart';

class Dot extends StatelessWidget {
  final bool active;

  const Dot({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary400
            : AppColors.primary400.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
