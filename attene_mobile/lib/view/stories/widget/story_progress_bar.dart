import '../../../general_index.dart';

class StoryProgressBar extends StatelessWidget {
  final int count;
  final int activeIndex;
  final double progress; // 0..1 for active

  const StoryProgressBar({
    super.key,
    required this.count,
    required this.activeIndex,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final isActive = i == activeIndex;
        final isDone = i < activeIndex;
        return Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(999),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: isDone ? 1 : (isActive ? progress.clamp(0, 1) : 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
