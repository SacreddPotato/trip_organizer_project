class Money {
  final double amount;
  final String currencyCode;

  Money({required this.amount, required this.currencyCode});

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'currencyCode': currencyCode,
  };

  factory Money.fromJson(Map<String, dynamic> json) {
  return Money(
    amount: (json['amount'] as num).toDouble(),
    currencyCode: json['currencyCode'] as String,
  );
}

}