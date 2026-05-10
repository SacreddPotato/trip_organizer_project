import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';
import 'package:trip_organizer_project/presentation/widgets/labeled_text_field.dart';
import 'package:trip_organizer_project/presentation/widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _avatarController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppStore>().profile;
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _avatarController = TextEditingController(text: profile.avatarUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = _avatarController.text.trim();

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
          children: [
            // Avatar preview
            Center(
              child: Stack(
                children: [
                  avatarUrl.isEmpty
                      ? CircleAvatar(
                          radius: 60,
                          backgroundColor: context.appColors.iconBgBlue,
                          child: Text(
                            _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : '?',
                            style: TextStyle(fontSize: 48, color: context.appColors.primary),
                          ),
                        )
                      : ClipOval(
                          child: Image.network(
                            avatarUrl,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => CircleAvatar(
                              radius: 60,
                              backgroundColor: context.appColors.iconBgBlue,
                              child: Text(
                                _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : '?',
                                style: TextStyle(fontSize: 48, color: context.appColors.primary),
                              ),
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.appColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Profile form fields
            LabeledTextField(
              label: 'Full Name',
              controller: _nameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            LabeledTextField(
              label: 'Email Address',
              controller: _emailController,
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            LabeledTextField(
              label: 'Avatar URL',
              controller: _avatarController,
              icon: Icons.image_outlined,
            ),
            const SizedBox(height: 32),
            // Save profile action
            PrimaryButton(
              label: _isSaving ? 'Saving...' : 'Save Changes',
              onPressed: _isSaving ? null : _saveProfile,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and email are required.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    await context.read<AppStore>().updateProfile(
      name: name,
      email: email,
      avatarUrl: _avatarController.text.trim(),
    );
    if (!mounted) return;
    Navigator.pop(context);
  }
}
