import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/constants/app_colors.dart';
import 'package:trip_organizer_project/presentation/screens/profile/edit_profile_screen.dart';
import 'package:trip_organizer_project/presentation/screens/profile/notifications_screen.dart';
import 'package:trip_organizer_project/presentation/screens/profile/security_screen.dart';
import 'package:trip_organizer_project/presentation/screens/simple_info_screen.dart';
import 'package:trip_organizer_project/presentation/widgets/app_bar.dart';
import 'package:trip_organizer_project/presentation/widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AppStore>().profile;
    final avatarUrl = profile.avatarUrl.isEmpty
        ? 'https://i.pravatar.cc/150?img=32'
        : profile.avatarUrl;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: const MyAppBar(),
      bottomNavigationBar: const MyBottomNavBar(selectedIndex: 2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      color: AppColors.iconBgBlue,
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.primary,
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
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                profile.email,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              _buildProfileOption(
                context,
                Icons.edit,
                'Edit Profile',
                const EditProfileScreen(),
              ),
              _buildProfileOption(
                context,
                Icons.security,
                'Security',
                const SecurityScreen(),
              ),
              _buildProfileOption(
                context,
                Icons.notifications_active_outlined,
                'Notifications',
                const NotificationsScreen(),
              ),
              _buildProfileOption(
                context,
                Icons.help_outline,
                'Help & Support',
                const SimpleInfoScreen(
                  title: 'Help & Support',
                  content:
                      'Contact us at support@voyageapp.com for any inquiries or assistance with your trips.',
                ),
              ),
              const SizedBox(height: 20),
              _buildProfileOption(
                context,
                Icons.logout,
                'Log Out',
                null,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to keep the code clean and avoid repetition
  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String title,
    Widget? destination, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? AppColors.iconBgRed : AppColors.iconBgBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? AppColors.accent : AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive ? AppColors.accent : AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: () {
          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
      ),
    );
  }
}
