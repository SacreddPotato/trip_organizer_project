class Reminder {
  final String id;
  final String tripId;
  final String? itineraryItemId; // nullable — reminder can be trip-level or item-level
  String message;
  DateTime remindAt;
  bool isCompleted;

  Reminder({
    required this.id,
    required this.tripId,
    this.itineraryItemId,
    required this.message,
    required this.remindAt,
    this.isCompleted = false,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      itineraryItemId: json['itineraryItemId'] as String?,
      message: json['message'] as String,
      remindAt: DateTime.parse(json['remindAt'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'itineraryItemId': itineraryItemId,
        'message': message,
        'remindAt': remindAt.toIso8601String(),
        'isCompleted': isCompleted,
      };
}
