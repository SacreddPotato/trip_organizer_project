import 'package:trip_organizer_project/enums/trip_enums.dart';

class TripMember {
  final String id;
  final String tripId;
  final String userId;
  TripRole role;
  final DateTime joinedAt;

  TripMember({
    required this.id,
    required this.tripId,
    required this.userId,
    required this.role,
    required this.joinedAt,
  });

  factory TripMember.fromJson(Map<String, dynamic> json) {
    return TripMember(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      userId: json['userId'] as String,
      role: TripRole.values.byName(json['role'] as String),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'userId': userId,
        'role': role.name,
        'joinedAt': joinedAt.toIso8601String(),
      };
}
