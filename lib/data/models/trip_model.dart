import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String id;
  final String destination;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;

  const Trip({
    required this.id,
    required this.destination,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.budget,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      destination: json['destination'] as String,
      title: json['title'] as String,
      startDate: _toDateTime(json['startDate']),
      endDate: _toDateTime(json['endDate']),
      budget: (json['budget'] as num).toDouble(),
    );
  }

  static DateTime _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return DateTime.parse(value as String);
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'destination': destination,
      'title': title,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'budget': budget,
    };
  }
}
