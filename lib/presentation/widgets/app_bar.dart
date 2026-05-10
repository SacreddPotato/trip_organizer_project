import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Icon(Icons.explore, color: context.appColors.primary),
      title: Text(
        'Voyage',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: context.appColors.textPrimary,
        ),
      ),
      titleSpacing: 0,
    );
  }
}
