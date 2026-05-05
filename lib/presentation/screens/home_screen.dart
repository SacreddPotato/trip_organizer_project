import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/constants/app_colors.dart';
import 'package:trip_organizer_project/presentation/widgets/app_bar.dart';
import 'package:trip_organizer_project/presentation/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MyBottomNavBar(selectedIndex: 0),
      appBar: MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 86,
                backgroundColor: AppColors.primary.withOpacity(0.3),
                child: Icon(Icons.directions_boat_rounded, size: 86),
              ),
              SizedBox(height: 12),
              Text(
                "No trips planned yet",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Every great journey starts with a single step. Start planning your first trip now!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              SizedBox(height:12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add_trip');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFfe7d50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fixedSize: Size(200, 48),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.add_location_alt, color: Colors.white), Text('Plan a Trip', style: TextStyle(color: Colors.white))],
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/browse_destinations');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text("Browse Destinations", style: TextStyle(color: AppColors.primary)),
                  ]
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
