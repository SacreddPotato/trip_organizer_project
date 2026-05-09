import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/constants/app_colors.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _destinationController = TextEditingController();
  final _tripNameController = TextEditingController();
  final _budgetController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  bool _isSaving = false;

  @override
  void dispose() {
    _destinationController.dispose();
    _tripNameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Plan a Trip',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Where to next?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              label: 'Destination',
              hint: 'e.g. Paris, France',
              icon: Icons.location_on_outlined,
              controller: _destinationController,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Trip Name',
              hint: 'e.g. Summer Vacation',
              icon: Icons.card_travel_outlined,
              controller: _tripNameController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Start Date',
                    hint: _formatDate(_startDate),
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: () => _pickDate(isStart: true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'End Date',
                    hint: _formatDate(_endDate),
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: () => _pickDate(isStart: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Budget',
              hint: r'$0.00',
              icon: Icons.attach_money,
              controller: _budgetController,
              isNumber: true,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveTrip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _isSaving ? 'Creating...' : 'Create Trip',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    bool readOnly = false,
    bool isNumber = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textLight),
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.cardBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (selected == null) return;
    setState(() {
      if (isStart) {
        _startDate = selected;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      } else {
        _endDate = selected;
      }
    });
  }

  Future<void> _saveTrip() async {
    final destination = _destinationController.text.trim();
    final title = _tripNameController.text.trim();
    if (destination.isEmpty || title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Destination and trip name are required.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    await context.read<AppStore>().createTrip(
      destination: destination,
      title: title,
      startDate: _startDate,
      endDate: _endDate,
      budget: _parseMoney(_budgetController.text),
    );
    if (!mounted) return;
    Navigator.pop(context);
  }

  double _parseMoney(String value) {
    final normalized = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(normalized) ?? 0;
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
