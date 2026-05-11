import 'package:trip_organizer_project/enums/trip_enums.dart';

class ItineraryItem {
  final String id;
  final String tripId;
  String title;
  String? notes;
  DateTime startsAt;
  DateTime endsAt;
  ItineraryStatus status;
  int sortOrder;

  ItineraryItem({
    required this.id,
    required this.tripId,
    required this.title,
    this.notes,
    required this.startsAt,
    required this.endsAt,
    this.status = ItineraryStatus.planned,
    required this.sortOrder,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      title: json['title'] as String,
      notes: json['notes'] as String?,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      status: ItineraryStatus.values.byName(json['status'] as String),
      sortOrder: json['sortOrder'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'title': title,
        'notes': notes,
        'startsAt': startsAt.toIso8601String(),
        'endsAt': endsAt.toIso8601String(),
        'status': status.name,
        'sortOrder': sortOrder,
      };
}
