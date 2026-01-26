class DrawerAccount {
  final int id;
  final String name;
  final String? avatar; // يمكن أن تكون null أو رابط
  final String? type; // products | services ...

  DrawerAccount({
    required this.id,
    required this.name,
    this.avatar,
    this.type,
  });

  factory DrawerAccount.fromStoreJson(Map<String, dynamic> json) {
    return DrawerAccount(
      id: int.tryParse('${json['id'] ?? ''}') ?? 0,
      name: (json['name'] ?? '').toString(),
      avatar: (json['logo_url'] ?? json['avatar_url'] ?? json['logo'] ?? '').toString().trim().isEmpty
          ? null
          : (json['logo_url'] ?? json['avatar_url'] ?? json['logo']).toString(),
      type: (json['type'] ?? '').toString(),
    );
  }
}
