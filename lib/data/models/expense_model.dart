import 'package:trip_organizer_project/data/models/money_model.dart';
import 'package:trip_organizer_project/enums/trip_enums.dart';

class Expense {
  final String id;
  final String tripId;
  final String budgetId;
  String title;
  Money amount;
  ExpenseType expenseType;
  ExpenseCategory category;
  DateTime spentAt;
  String? notes;

  Expense({
    required this.id,
    required this.tripId,
    required this.budgetId,
    required this.title,
    required this.amount,
    required this.expenseType,
    required this.category,
    required this.spentAt,
    this.notes,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      budgetId: json['budgetId'] as String,
      title: json['title'] as String,
      amount: Money.fromJson(json['amount'] as Map<String, dynamic>),
      expenseType: ExpenseType.values.byName(json['expenseType'] as String),
      category: ExpenseCategory.values.byName(json['category'] as String),
      spentAt: DateTime.parse(json['spentAt'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'budgetId': budgetId,
        'title': title,
        'amount': amount.toJson(),
        'expenseType': expenseType.name,
        'category': category.name,
        'spentAt': spentAt.toIso8601String(),
        'notes': notes,
      };
}
