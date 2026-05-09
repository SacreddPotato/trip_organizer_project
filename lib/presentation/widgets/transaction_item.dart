import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/constants/app_colors.dart';
import 'package:trip_organizer_project/data/models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  Color get _iconBgColor {
    switch (transaction.category) {
      case TransactionCategory.personal:
        return AppColors.iconBgRed;
      case TransactionCategory.travel:
        return AppColors.iconBgBlue;
      case TransactionCategory.other:
        return AppColors.iconBgGray;
    }
  }

  Color get _iconColor {
    switch (transaction.category) {
      case TransactionCategory.personal:
        return AppColors.personalTagText;
      case TransactionCategory.travel:
        return AppColors.travelTagText;
      case TransactionCategory.other:
        return AppColors.otherTagText;
    }
  }

  Color get _tagBgColor {
    switch (transaction.category) {
      case TransactionCategory.personal:
        return AppColors.personalTagBg;
      case TransactionCategory.travel:
        return AppColors.travelTagBg;
      case TransactionCategory.other:
        return AppColors.otherTagBg;
    }
  }

  Color get _tagTextColor {
    switch (transaction.category) {
      case TransactionCategory.personal:
        return AppColors.personalTagText;
      case TransactionCategory.travel:
        return AppColors.travelTagText;
      case TransactionCategory.other:
        return AppColors.otherTagText;
    }
  }

  IconData get _iconData {
    switch (transaction.expenseType) {
      case ExpenseType.dining:
        return Icons.restaurant;
      case ExpenseType.transit:
        return Icons.train;
      case ExpenseType.shopping:
        return Icons.shopping_bag;
      case ExpenseType.activities:
        return Icons.museum;
      case ExpenseType.transport:
        return Icons.directions_bus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(_iconData, color: _iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          // Title and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.dateLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Amount and tag
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.formattedAmount,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _tagBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  transaction.categoryLabel,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: _tagTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
