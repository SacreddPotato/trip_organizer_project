import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/theme/app_theme.dart';
import 'package:trip_organizer_project/presentation/screens/budget/budget_screen.dart';
import 'package:trip_organizer_project/presentation/screens/home_screen.dart';

void main() {
  runApp(const VoyageApp());
}

class VoyageApp extends StatelessWidget {
  const VoyageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voyage',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routes: {
        '/': (context) => HomeScreen(),
        '/budget': (context) => const BudgetScreen(),
      }
    );
  }
}
