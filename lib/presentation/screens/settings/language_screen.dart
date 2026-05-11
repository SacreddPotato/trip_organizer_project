import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/constants/app_colors.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Language', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildLanguageTile('English'),
          _buildLanguageTile('Spanish (Español)'),
          _buildLanguageTile('French (Français)'),
          _buildLanguageTile('German (Deutsch)'),
          _buildLanguageTile('Italian (Italiano)'),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(String language) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: RadioListTile<String>(
        title: Text(language, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        value: language,
        groupValue: selectedLanguage,
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              selectedLanguage = value;
            });
          }
        },
        activeColor: AppColors.primary,
      ),
    );
  }
}
