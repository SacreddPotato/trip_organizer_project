class UserProfile {
  final String name;
  final String email;
  final String avatarUrl;

  const UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'avatarUrl': avatarUrl};
  }
}

class UserPreferences {
  final bool darkModeEnabled;

  const UserPreferences({required this.darkModeEnabled});

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'darkModeEnabled': darkModeEnabled};
  }
}
