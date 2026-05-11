import 'package:trip_organizer_project/enums/trip_enums.dart';

// Named TripNotification to avoid conflict with Flutter's built-in Notification class
class TripNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  bool isRead;
  final DateTime createdAt;

  TripNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  factory TripNotification.fromJson(Map<String, dynamic> json) {
    return TripNotification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.byName(json['type'] as String),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
        'type': type.name,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
      };
}
