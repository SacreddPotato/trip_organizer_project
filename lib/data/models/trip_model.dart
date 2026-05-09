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
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      budget: (json['budget'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destination': destination,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'budget': budget,
    };
  }
}
