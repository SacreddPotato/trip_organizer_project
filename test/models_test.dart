import 'package:flutter_test/flutter_test.dart';
import 'package:trip_organizer_project/data/models/money_model.dart';
import 'package:trip_organizer_project/data/models/budget_model.dart';
import 'package:trip_organizer_project/data/models/user_model.dart';
import 'package:trip_organizer_project/data/models/expense_model.dart';
import 'package:trip_organizer_project/enums/trip_enums.dart';

void main() {
  test('Money: fromJson and toJson roundtrip', () {
    final money = Money(amount: 99.99, currencyCode: 'USD');
    final json = money.toJson();
    final restored = Money.fromJson(json);
    expect(restored.amount, 99.99);
    expect(restored.currencyCode, 'USD');
  });

  test('Budget: remainingAmount and percentConsumed', () {
    final budget = Budget(
      id: 'b1', tripId: 't1',
      totalAmount: Money(amount: 1000, currencyCode: 'USD'),
      spentAmount: Money(amount: 250, currencyCode: 'USD'),
    );
    expect(budget.remainingAmount().amount, 750);
    expect(budget.percentConsumed(), 25.0);
  });

  test('User: fromJson and toJson roundtrip', () {
    final user = User(
      id: 'u1', fullName: 'Ahmed', email: 'ahmed@test.com',
      createdAt: DateTime(2024, 1, 1),
    );
    final json = user.toJson();
    final restored = User.fromJson(json);
    expect(restored.fullName, 'Ahmed');
    expect(restored.email, 'ahmed@test.com');
  });

  test('Expense: enum serialization', () {
    final expense = Expense(
      id: 'e1', tripId: 't1', budgetId: 'b1',
      title: 'Lunch',
      amount: Money(amount: 25, currencyCode: 'USD'),
      expenseType: ExpenseType.dining,
      category: ExpenseCategory.personal,
      spentAt: DateTime.now(),
    );
    final json = expense.toJson();
    expect(json['expenseType'], 'dining');
    expect(json['category'], 'personal');
  });
}
