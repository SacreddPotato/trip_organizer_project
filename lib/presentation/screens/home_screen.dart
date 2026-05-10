import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';
import 'package:trip_organizer_project/presentation/screens/home/widgets/trip_card.dart';
import 'package:trip_organizer_project/presentation/widgets/app_bar.dart';
import 'package:trip_organizer_project/presentation/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();

    return Scaffold(
      bottomNavigationBar: const MyBottomNavBar(selectedIndex: 0),
      appBar: const MyAppBar(),
      body: store.trips.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Empty trips illustration
                    CircleAvatar(
                      radius: 86,
                      backgroundColor: context.appColors.primary.withValues(
                        alpha: 0.3,
                      ),
                      child: const Icon(
                        Icons.directions_boat_rounded,
                        size: 86,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Empty trips message
                    Text(
                      'No trips planned yet',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: context.appColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Every great journey starts with a single step. Start planning your first trip now!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: context.appColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Empty trips actions
                    ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/add_trip'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.appColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fixedSize: const Size(200, 48),
                      ),
                      icon: const Icon(
                        Icons.add_location_alt,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Plan a Trip',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/browse_destinations'),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: context.appColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Browse Destinations',
                            style: TextStyle(color: context.appColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Trip list header
                Row(
                  children: [
                    Text(
                      'Your Trips',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: context.appColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/add_trip'),
                      icon: const Icon(Icons.add_location_alt),
                      color: context.appColors.accent,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Planned trips
                ...store.trips.map((trip) => TripCard(trip: trip)),
              ],
            ),
    );
  }
}
