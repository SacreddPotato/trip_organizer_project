import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';

class MenuCardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const MenuCardTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.appColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.appColors.iconBgBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: context.appColors.primary),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: context.appColors.textPrimary,
          ),
        ),
        subtitle: subtitle == null || subtitle!.isEmpty
            ? null
            : Text(
                subtitle!,
                style: TextStyle(color: context.appColors.textSecondary),
              ),
        trailing:
            trailing ??
            Icon(Icons.chevron_right, color: context.appColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
