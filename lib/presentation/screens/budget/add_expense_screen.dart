import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';
import 'package:trip_organizer_project/data/models/transaction_model.dart';
import 'package:trip_organizer_project/presentation/widgets/labeled_dropdown.dart';
import 'package:trip_organizer_project/presentation/widgets/labeled_text_field.dart';
import 'package:trip_organizer_project/presentation/widgets/primary_button.dart';

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
      backgroundColor: context.appColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Add Expense',
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
              'New Expense',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: context.appColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            // Expense form fields
            LabeledTextField(
              label: 'Amount',
              hint: r'$0.00',
              icon: Icons.attach_money,
              isNumber: true,
              controller: _amountController,
            ),
            const SizedBox(height: 16),
            LabeledTextField(
              label: 'Description',
              hint: 'e.g. Dinner at Luigi\'s',
              icon: Icons.description_outlined,
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            LabeledDropdown<ExpenseType>(
              label: 'Type',
              value: _expenseType,
              values: ExpenseType.values,
              labelFor: (value) => value.name,
              onChanged: (value) => setState(() => _expenseType = value),
            ),
            const SizedBox(height: 16),
            LabeledDropdown<TransactionCategory>(
              label: 'Category',
              value: _category,
              values: TransactionCategory.values,
              labelFor: (value) => value.name,
              onChanged: (value) => setState(() => _category = value),
            ),
            const SizedBox(height: 16),
            LabeledTextField(
              label: 'Date',
              hint: _formatDate(_date),
              icon: Icons.calendar_today,
              readOnly: true,
              onTap: _pickDate,
            ),
            const SizedBox(height: 32),
            // Save expense action
            PrimaryButton(
              label: _isSaving ? 'Saving...' : 'Save Expense',
              onPressed: _isSaving ? null : _saveExpense,
            ),
          ],
        ),
      ),
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
