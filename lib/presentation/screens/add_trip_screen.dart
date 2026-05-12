import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';
import 'package:trip_organizer_project/presentation/widgets/labeled_text_field.dart';
import 'package:trip_organizer_project/presentation/widgets/primary_button.dart';

class AddTripScreen extends StatefulWidget {
  final String? initialDestination;

  const AddTripScreen({super.key, this.initialDestination});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  late final TextEditingController _destinationController;
  final _tripNameController = TextEditingController();
  final _budgetController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _destinationController = TextEditingController(
      text: widget.initialDestination ?? '',
    );
  }

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
      backgroundColor: context.appColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Plan a Trip',
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
            // Screen title
            Text(
              'Where to next?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: context.appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            // Trip form fields
            LabeledTextField(
              label: 'Destination',
              hint: 'e.g. Paris, France',
              icon: Icons.location_on_outlined,
              controller: _destinationController,
            ),
            const SizedBox(height: 16),
            LabeledTextField(
              label: 'Trip Name',
              hint: 'e.g. Summer Vacation',
              icon: Icons.card_travel_outlined,
              controller: _tripNameController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    label: 'Start Date',
                    hint: _formatDate(_startDate),
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: () => _pickDate(isStart: true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: LabeledTextField(
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
            LabeledTextField(
              label: 'Budget',
              hint: r'$0.00',
              icon: Icons.attach_money,
              controller: _budgetController,
              isNumber: true,
            ),
            const SizedBox(height: 32),
            // Create trip action
            PrimaryButton(
              label: _isSaving ? 'Creating...' : 'Create Trip',
              onPressed: _isSaving ? null : _saveTrip,
            ),
          ],
        ),
      ),
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
