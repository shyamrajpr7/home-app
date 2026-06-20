class HomeUser {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final bool notificationsEnabled;
  final DateTime? createdAt;

  HomeUser({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.notificationsEnabled = true,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory HomeUser.fromJson(String uid, Map<String, dynamic> json) {
    return HomeUser(
      uid: uid,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}
