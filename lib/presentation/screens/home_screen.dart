import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/constants/app_colors.dart';
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
          ? const _EmptyTripsView()
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  children: [
                    const Text(
                      'Your Trips',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/add_trip'),
                      icon: const Icon(Icons.add_location_alt),
                      color: AppColors.accent,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...store.trips.map((trip) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.iconBgBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.flight_takeoff,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trip.destination,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }
}

class _EmptyTripsView extends StatelessWidget {
  const _EmptyTripsView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 86,
              backgroundColor: AppColors.primary.withOpacity(0.3),
              child: const Icon(Icons.directions_boat_rounded, size: 86),
            ),
            const SizedBox(height: 12),
            const Text(
              'No trips planned yet',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Every great journey starts with a single step. Start planning your first trip now!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const _PlanTripButton(),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/browse_destinations'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Browse Destinations',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanTripButton extends StatelessWidget {
  const _PlanTripButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, '/add_trip'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFfe7d50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        fixedSize: const Size(200, 48),
      ),
      child: const FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_location_alt, color: Colors.white),
            SizedBox(width: 8),
            Text('Plan a Trip', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
