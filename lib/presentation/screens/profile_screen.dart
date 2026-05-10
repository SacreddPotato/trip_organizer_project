import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/providers/auth_provider.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';
import 'package:trip_organizer_project/presentation/screens/profile/edit_profile_screen.dart';
import 'package:trip_organizer_project/presentation/widgets/app_bar.dart';
import 'package:trip_organizer_project/presentation/widgets/bottom_nav_bar.dart';
import 'package:trip_organizer_project/presentation/widgets/menu_card_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    // Capture navigator before async gap — context may be invalid after await
    final navigator = Navigator.of(context);
    await context.read<AuthProvider>().signOut();
    navigator.pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AppStore>().profile;
    final avatarUrl = profile.avatarUrl;

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
              avatarUrl.isEmpty
                  ? CircleAvatar(
                      radius: 60,
                      backgroundColor: context.appColors.iconBgBlue,
                      child: Text(
                        profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                        style: TextStyle(fontSize: 48, color: context.appColors.primary),
                      ),
                    )
                  : ClipOval(
                      child: Image.network(
                        avatarUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            radius: 60,
                            backgroundColor: context.appColors.iconBgBlue,
                            child: Text(
                              profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                              style: TextStyle(fontSize: 48, color: context.appColors.primary),
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
              const SizedBox(height: 12),
              MenuCardTile(
                icon: _isSigningOut ? Icons.hourglass_empty : Icons.logout,
                title: _isSigningOut ? 'Signing out...' : 'Sign Out',
                onTap: _isSigningOut ? null : _signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
