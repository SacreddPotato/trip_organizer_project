import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';
import 'package:trip_organizer_project/presentation/screens/browse_destinations/widgets/destination_card.dart';

class BrowseDestinationsScreen extends StatelessWidget {
  const BrowseDestinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final destinations = context.watch<AppStore>().popularDestinations;

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Browse Destinations',
          style: TextStyle(
            color: context.appColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: context.appColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Popular destinations
            Text(
              'Popular Places',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            // Destination results
            for (final destination in destinations)
              DestinationCard(
                title: destination.title,
                subtitle: destination.subtitle,
                icon: _iconForDestination(destination.iconName),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/add_trip',
                  arguments: destination.title,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconForDestination(String iconName) {
    return switch (iconName) {
      'landscape' => Icons.landscape,
      'beach' => Icons.beach_access,
      'history' => Icons.account_balance,
      'nature' => Icons.park,
      _ => Icons.place,
    };
  }
}
