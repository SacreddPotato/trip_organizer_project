class Budget {
  final double totalBudget;
  final double spent;

  const Budget({required this.totalBudget, required this.spent});

  double get remaining => totalBudget - spent;

  double get percentConsumed {
    if (totalBudget <= 0) return 0;
    return (spent / totalBudget) * 100;
  }

  String get formattedTotal => '\$${totalBudget.toStringAsFixed(2)}';
  String get formattedSpent => '\$${spent.toStringAsFixed(2)}';
  String get formattedRemaining => '\$${remaining.toStringAsFixed(2)}';
}
