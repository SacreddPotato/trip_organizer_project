import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';
import 'package:trip_organizer_project/presentation/widgets/app_bar.dart';
import 'package:trip_organizer_project/presentation/widgets/bottom_nav_bar.dart';
import 'package:trip_organizer_project/presentation/widgets/menu_card_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<AppStore>().preferences;

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBg,
      appBar: const MyAppBar(),
      bottomNavigationBar: const MyBottomNavBar(selectedIndex: 3),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: context.appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              // Theme preference
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
                child: Text(
                  'GENERAL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: context.appColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              MenuCardTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: preferences.darkModeEnabled ? 'On' : 'Off',
                trailing: Switch(
                  value: preferences.darkModeEnabled,
                  onChanged: (value) {
                    context.read<AppStore>().updatePreferences(
                      darkModeEnabled: value,
                    );
                  },
                  activeThumbColor: context.appColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
