import 'package:trip_organizer_project/enums/trip_enums.dart';

class Activity {
  final String id;
  final String itineraryItemId;
  ActivityType type;
  String locationName;
  double latitude;
  double longitude;

  Activity({
    required this.id,
    required this.itineraryItemId,
    required this.type,
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      itineraryItemId: json['itineraryItemId'] as String,
      type: ActivityType.values.byName(json['type'] as String),
      locationName: json['locationName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'itineraryItemId': itineraryItemId,
        'type': type.name,
        'locationName': locationName,
        'latitude': latitude,
        'longitude': longitude,
      };
}
