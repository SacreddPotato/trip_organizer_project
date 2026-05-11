class Destination {
  final String id;
  final String tripId;
  String name;
  String country;
  double latitude;
  double longitude;

  Destination({
    required this.id,
    required this.tripId,
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'name': name,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
      };
}
