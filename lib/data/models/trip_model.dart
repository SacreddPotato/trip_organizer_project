import 'package:trip_organizer_project/enums/trip_enums.dart';

class Trip {
  final String id;
  final String ownerId;
  String title;
  String? description;
  String? coverImageUrl;
  DateTime startDate;
  DateTime endDate;
  TripStatus status;
  final DateTime createdAt;

  Trip({
    required this.id,
    required this.ownerId,
    required this.title,
    this.description,
    this.coverImageUrl,
    required this.startDate,
    required this.endDate,
    this.status = TripStatus.draft,
    required this.createdAt,
  });
}