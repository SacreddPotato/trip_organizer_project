import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/theme/app_theme.dart';
import 'package:trip_organizer_project/presentation/screens/add_trip_screen.dart';
import 'package:trip_organizer_project/presentation/screens/browse_destinations_screen.dart';
import 'package:trip_organizer_project/presentation/screens/budget/add_expense_screen.dart';
import 'package:trip_organizer_project/presentation/screens/budget/budget_screen.dart';
import 'package:trip_organizer_project/presentation/screens/home_screen.dart';
import 'package:trip_organizer_project/presentation/screens/profile_screen.dart';
import 'package:trip_organizer_project/presentation/screens/settings_screen.dart';

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
        '/': (context) => const HomeScreen(),
        '/budget': (context) => const BudgetScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/add_trip': (context) => const AddTripScreen(),
        '/browse_destinations': (context) => const BrowseDestinationsScreen(),
        '/add_expense': (context) => const AddExpenseScreen(),
      }
    );
  }
}
