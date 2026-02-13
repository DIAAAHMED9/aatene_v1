class FollowerModel {
  final int id;
  final String name;
  final String avatar;
  final int followersCount;
  final String followedType;

  FollowerModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.followersCount,
    required this.followedType,
  });

  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    return FollowerModel(
      id: json['id'] ?? 0,
      name: json['fullname'] ?? '',
      avatar: json['avatar'] ?? '',
      followersCount: json['followers_count'] ?? 0,
      followedType: json['type'] ?? 'user',
    );
  }
}
