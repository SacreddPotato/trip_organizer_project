import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/constants/app_colors.dart';
import 'package:trip_organizer_project/data/models/transaction_model.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  ExpenseType _expenseType = ExpenseType.dining;
  TransactionCategory _category = TransactionCategory.travel;
  DateTime _date = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Add Expense',
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
              'New Expense',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              label: 'Amount',
              hint: r'$0.00',
              icon: Icons.attach_money,
              isNumber: true,
              controller: _amountController,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Description',
              hint: 'e.g. Dinner at Luigi\'s',
              icon: Icons.description_outlined,
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            _buildDropdown<ExpenseType>(
              label: 'Type',
              value: _expenseType,
              values: ExpenseType.values,
              labelFor: (value) => value.name,
              onChanged: (value) => setState(() => _expenseType = value),
            ),
            const SizedBox(height: 16),
            _buildDropdown<TransactionCategory>(
              label: 'Category',
              value: _category,
              values: TransactionCategory.values,
              labelFor: (value) => value.name,
              onChanged: (value) => setState(() => _category = value),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Date',
              hint: _formatDate(_date),
              icon: Icons.calendar_today,
              readOnly: true,
              onTap: _pickDate,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _isSaving ? 'Saving...' : 'Save Expense',
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
    bool readOnly = false,
    bool isNumber = false,
    TextEditingController? controller,
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

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> values,
    required String Function(T value) labelFor,
    required ValueChanged<T> onChanged,
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
        DropdownButtonFormField<T>(
          initialValue: value,
          items: values.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(labelFor(item)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          decoration: InputDecoration(
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

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (selected != null) {
      setState(() => _date = selected);
    }
  }

  Future<void> _saveExpense() async {
    final store = context.read<AppStore>();
    final title = _titleController.text.trim();
    final amount = _parseMoney(_amountController.text);

    if (store.activeTrip == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Create a trip before adding expenses.')),
      );
      return;
    }
    if (title.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a description and amount.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    await store.addExpense(
      title: title,
      amount: amount,
      expenseType: _expenseType,
      category: _category,
      date: _date,
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
