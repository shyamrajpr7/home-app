class Room {
  final String id;
  final String name;
  final String icon;
  final int deviceCount;
  final DateTime createdAt;

  Room({
    required this.id,
    required this.name,
    this.icon = 'home',
    this.deviceCount = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'deviceCount': deviceCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Room.fromJson(String id, Map<String, dynamic> json) {
    return Room(
      id: id,
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? 'home',
      deviceCount: (json['deviceCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
