class FollowerModel {
  final String name;
  final String avatar;
  final int followersCount;
  bool isFollowing;

  FollowerModel({
    required this.name,
    required this.avatar,
    required this.followersCount,
    this.isFollowing = true,
  });
}
