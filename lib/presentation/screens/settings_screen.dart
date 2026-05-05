import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/constants/app_colors.dart';
import 'package:trip_organizer_project/presentation/screens/settings/data_usage_screen.dart';
import 'package:trip_organizer_project/presentation/screens/settings/language_screen.dart';
import 'package:trip_organizer_project/presentation/screens/settings/privacy_screen.dart';
import 'package:trip_organizer_project/presentation/screens/simple_info_screen.dart';
import 'package:trip_organizer_project/presentation/widgets/app_bar.dart';
import 'package:trip_organizer_project/presentation/widgets/bottom_nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: const MyAppBar(),
      bottomNavigationBar: const MyBottomNavBar(selectedIndex: 3),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('General'),
              _buildSettingsTile(context, Icons.language, 'Language', 'English', const LanguageScreen()),
              _buildSettingsTile(context, Icons.dark_mode_outlined, 'Dark Mode', 'Off', null, isSwitch: true),
              const SizedBox(height: 24),
              _buildSectionTitle('Account'),
              _buildSettingsTile(context, Icons.lock_outline, 'Privacy', '', const PrivacyScreen()),
              _buildSettingsTile(context, Icons.download_outlined, 'Data Usage', '', const DataUsageScreen()),
              const SizedBox(height: 24),
              _buildSectionTitle('About'),
              _buildSettingsTile(context, Icons.info_outline, 'Terms of Service', '', const SimpleInfoScreen(title: 'Terms of Service', content: 'These are the terms of service. Please read them carefully.')),
              _buildSettingsTile(context, Icons.privacy_tip_outlined, 'Privacy Policy', '', const SimpleInfoScreen(title: 'Privacy Policy', content: 'This is the privacy policy. Your data is secure with us.')),
              _buildSettingsTile(context, Icons.star_rate_outlined, 'Rate Us', '', const SimpleInfoScreen(title: 'Rate Us', content: 'Thank you for considering rating our app!')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, String subtitle, Widget? destination, {bool isSwitch = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: isSwitch
            ? Switch(
                value: false,
                onChanged: (val) {},
                activeColor: AppColors.primary,
              )
            : const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
        onTap: isSwitch
            ? null
            : () {
                if (destination != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
                }
              },
      ),
    );
  }
}

