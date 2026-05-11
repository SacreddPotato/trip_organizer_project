import 'package:trip_organizer_project/data/models/budget_model.dart';
import 'package:trip_organizer_project/data/models/expense_model.dart';
import 'package:trip_organizer_project/data/models/money_model.dart';
import 'package:trip_organizer_project/enums/trip_enums.dart';

/// Manages budget and expense tracking for a trip.
class BudgetService {
  final List<Budget> _budgets = [];
  final List<Expense> _expenses = [];

  /// Creates or replaces the budget for a trip.
  Budget setTripBudget({
    required String id,
    required String tripId,
    required double totalAmount,
    String currencyCode = 'USD',
  }) {
    // Remove any existing budget for this trip
    _budgets.removeWhere((b) => b.tripId == tripId);

    final budget = Budget(
      id: id,
      tripId: tripId,
      totalAmount: Money(amount: totalAmount, currencyCode: currencyCode),
      spentAmount: Money(amount: 0, currencyCode: currencyCode),
    );
    _budgets.add(budget);
    return budget;
  }

  /// Records a new expense and updates the budget's spentAmount.
  Expense addExpense({
    required String id,
    required String tripId,
    required String budgetId,
    required String title,
    required double amount,
    required ExpenseType expenseType,
    required ExpenseCategory category,
    DateTime? spentAt,
    String? notes,
    String currencyCode = 'USD',
  }) {
    final expense = Expense(
      id: id,
      tripId: tripId,
      budgetId: budgetId,
      title: title,
      amount: Money(amount: amount, currencyCode: currencyCode),
      expenseType: expenseType,
      category: category,
      spentAt: spentAt ?? DateTime.now(),
      notes: notes,
    );
    _expenses.add(expense);

    // Update the budget's spentAmount
    final budget = _budgets.firstWhere(
      (b) => b.id == budgetId,
      orElse: () => throw StateError('Budget not found: $budgetId'),
    );
    budget.spentAmount = Money(
      amount: budget.spentAmount.amount + amount,
      currencyCode: budget.spentAmount.currencyCode,
    );

    return expense;
  }

  /// Returns the budget summary for a trip, or null if no budget is set.
  Budget? getBudgetSummary(String tripId) {
    try {
      return _budgets.firstWhere((b) => b.tripId == tripId);
    } catch (_) {
      return null;
    }
  }

  /// Returns expenses filtered by category and/or type.
  /// Pass null to skip a filter (returns all).
  List<Expense> filterExpenses({
    required String tripId,
    ExpenseCategory? category,
    ExpenseType? expenseType,
  }) {
    return _expenses.where((e) {
      if (e.tripId != tripId) return false;
      if (category != null && e.category != category) return false;
      if (expenseType != null && e.expenseType != expenseType) return false;
      return true;
    }).toList();
  }
}
