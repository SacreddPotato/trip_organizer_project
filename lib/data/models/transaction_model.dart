enum TransactionCategory { personal, travel, other }

enum ExpenseType { dining, transit, shopping, activities, transport }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseType expenseType;
  final TransactionCategory category;
  final String iconAsset; // placeholder for icon identifier

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.expenseType,
    required this.category,
    required this.iconAsset,
  });

  String get formattedAmount => '-\$${amount.toStringAsFixed(2)}';

  String get categoryLabel {
    switch (category) {
      case TransactionCategory.personal:
        return 'PERSONAL';
      case TransactionCategory.travel:
        return 'TRAVEL';
      case TransactionCategory.other:
        return 'OTHER';
    }
  }

  String get expenseTypeLabel {
    switch (expenseType) {
      case ExpenseType.dining:
        return 'Dining';
      case ExpenseType.transit:
        return 'Transit';
      case ExpenseType.shopping:
        return 'Shopping';
      case ExpenseType.activities:
        return 'Activities';
      case ExpenseType.transport:
        return 'Transport';
    }
  }

  String get dateLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';
      return 'Today, $hour:$minute $period';
    } else if (transactionDate == yesterday) {
      return 'Yesterday \u2022 $expenseTypeLabel';
    } else {
      final monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${monthNames[date.month - 1]} ${date.day} \u2022 $expenseTypeLabel';
    }
  }
}
