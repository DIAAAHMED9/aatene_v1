import '../../../../general_index.dart';

class FollowersAvatars extends StatelessWidget {
  final List<String> images;
  final double size;

  const FollowersAvatars({
    super.key,
    required this.images,
    this.size = 15,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Stack(
        children: images
            .asMap()
            .entries
            .map((entry) {
          return Positioned(
            left: entry.key * (size * 0.6),
            child: CircleAvatar(
              radius: size / 2,
              backgroundImage: (entry.value.startsWith('http') || entry.value.startsWith('https'))
                ? NetworkImage(entry.value)
                : AssetImage(entry.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
