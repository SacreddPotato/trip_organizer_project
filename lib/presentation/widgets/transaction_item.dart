import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';
import 'package:trip_organizer_project/data/models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  Color _iconBgColor(BuildContext context) {
    switch (transaction.category) {
      case TransactionCategory.personal:
        return context.appColors.iconBgRed;
      case TransactionCategory.travel:
        return context.appColors.iconBgBlue;
      case TransactionCategory.other:
        return context.appColors.iconBgGray;
    }
  }

  Color _iconColor(BuildContext context) {
    switch (transaction.category) {
      case TransactionCategory.personal:
        return context.appColors.personalTagText;
      case TransactionCategory.travel:
        return context.appColors.travelTagText;
      case TransactionCategory.other:
        return context.appColors.otherTagText;
    }
  }

  Color _tagBgColor(BuildContext context) {
    switch (transaction.category) {
      case TransactionCategory.personal:
        return context.appColors.personalTagBg;
      case TransactionCategory.travel:
        return context.appColors.travelTagBg;
      case TransactionCategory.other:
        return context.appColors.otherTagBg;
    }
  }

  Color _tagTextColor(BuildContext context) {
    switch (transaction.category) {
      case TransactionCategory.personal:
        return context.appColors.personalTagText;
      case TransactionCategory.travel:
        return context.appColors.travelTagText;
      case TransactionCategory.other:
        return context.appColors.otherTagText;
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
        color: context.appColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
              color: _iconBgColor(context),
              shape: BoxShape.circle,
            ),
            child: Icon(_iconData, color: _iconColor(context), size: 22),
          ),
          const SizedBox(width: 14),
          // Title and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: context.appColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.dateLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
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
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _tagBgColor(context),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  transaction.categoryLabel,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: _tagTextColor(context),
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
