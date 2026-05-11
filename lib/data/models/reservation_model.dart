import 'package:trip_organizer_project/data/models/money_model.dart';

class Reservation {
  final String id;
  final String itineraryItemId;
  String providerName;
  String confirmationCode;
  String? detailsUrl;
  Money cost;

  Reservation({
    required this.id,
    required this.itineraryItemId,
    required this.providerName,
    required this.confirmationCode,
    this.detailsUrl,
    required this.cost,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      itineraryItemId: json['itineraryItemId'] as String,
      providerName: json['providerName'] as String,
      confirmationCode: json['confirmationCode'] as String,
      detailsUrl: json['detailsUrl'] as String?,
      cost: Money.fromJson(json['cost'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'itineraryItemId': itineraryItemId,
        'providerName': providerName,
        'confirmationCode': confirmationCode,
        'detailsUrl': detailsUrl,
        'cost': cost.toJson(),
      };
}
