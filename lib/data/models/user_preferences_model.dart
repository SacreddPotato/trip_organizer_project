class UserPreferences {
  final String id;
  final String userId;
  String currencyCode;
  bool pushNotificationsEnabled;
  bool darkModeEnabled;

  UserPreferences({
    required this.id,
    required this.userId,
    this.currencyCode = 'USD',
    this.pushNotificationsEnabled = true,
    this.darkModeEnabled = false,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      id: json['id'] as String,
      userId: json['userId'] as String,
      currencyCode: json['currencyCode'] as String? ?? 'USD',
      pushNotificationsEnabled:
          json['pushNotificationsEnabled'] as bool? ?? true,
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'currencyCode': currencyCode,
        'pushNotificationsEnabled': pushNotificationsEnabled,
        'darkModeEnabled': darkModeEnabled,
      };
}
