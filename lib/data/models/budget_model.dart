import 'package:trip_organizer_project/data/models/money_model.dart';

class Budget {
  final String id;
  final String tripId;
  final Money totalAmount;
  Money spentAmount;       // non-final — updated when expenses are added

  Budget({
    required this.id,
    required this.tripId,
    required this.totalAmount,
    required this.spentAmount,
  });

  // Computed — not stored, calculated on the fly
  Money remainingAmount() => Money(
        amount: totalAmount.amount - spentAmount.amount,
        currencyCode: totalAmount.currencyCode,
      );

  double percentConsumed() {
    if (totalAmount.amount == 0) return 0;
    return (spentAmount.amount / totalAmount.amount) * 100;
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      totalAmount: Money.fromJson(json['totalAmount'] as Map<String, dynamic>),
      spentAmount: Money.fromJson(json['spentAmount'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'totalAmount': totalAmount.toJson(),
        'spentAmount': spentAmount.toJson(),
      };
}
