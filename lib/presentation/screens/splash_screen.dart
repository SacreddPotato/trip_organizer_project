import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.scaffoldBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Voyage',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: context.appColors.primary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(color: context.appColors.primary),
          ],
        ),
      ),
    );
  }
}
