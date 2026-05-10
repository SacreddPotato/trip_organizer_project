import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final TextEditingController? controller;
  final bool readOnly;
  final bool isNumber;
  final bool obscureText;
  final VoidCallback? onTap;

  const LabeledTextField({
    super.key,
    required this.label,
    this.hint,
    this.icon,
    this.controller,
    this.readOnly = false,
    this.isNumber = false,
    this.obscureText = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.appColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: context.appColors.textLight),
            prefixIcon: icon == null
                ? null
                : Icon(icon, color: context.appColors.primary),
            filled: true,
            fillColor: context.appColors.cardBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }
}
