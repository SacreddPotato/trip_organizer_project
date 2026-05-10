import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';
import 'package:trip_organizer_project/presentation/screens/profile/edit_profile_screen.dart';
import 'package:trip_organizer_project/presentation/widgets/app_bar.dart';
import 'package:trip_organizer_project/presentation/widgets/bottom_nav_bar.dart';
import 'package:trip_organizer_project/presentation/widgets/menu_card_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AppStore>().profile;
    final avatarUrl = profile.avatarUrl.isEmpty
        ? 'https://i.pravatar.cc/150?img=32'
        : profile.avatarUrl;

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBg,
      appBar: const MyAppBar(),
      bottomNavigationBar: const MyBottomNavBar(selectedIndex: 2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile details
              const SizedBox(height: 20),
              ClipOval(
                child: Image.network(
                  avatarUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 120,
                      color: context.appColors.iconBgBlue,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: context.appColors.primary,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                profile.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                profile.email,
                style: TextStyle(
                  fontSize: 16,
                  color: context.appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              // Profile actions
              MenuCardTile(
                icon: Icons.edit,
                title: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
