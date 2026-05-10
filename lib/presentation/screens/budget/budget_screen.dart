import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';
import 'package:trip_organizer_project/data/models/transaction_model.dart';
import 'package:trip_organizer_project/presentation/widgets/bottom_nav_bar.dart';
import 'package:trip_organizer_project/presentation/widgets/budget_card.dart';
import 'package:trip_organizer_project/presentation/widgets/category_chip.dart';
import 'package:trip_organizer_project/presentation/widgets/transaction_item.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  String _selectedCategory = 'All';

  List<Transaction> _filteredTransactions(List<Transaction> transactions) {
    if (_selectedCategory == 'All') return transactions;
    return transactions.where((transaction) {
      if (_selectedCategory == 'Dining') {
        return transaction.expenseType == ExpenseType.dining;
      }
      if (_selectedCategory == 'Transit') {
        return transaction.expenseType == ExpenseType.transit ||
            transaction.expenseType == ExpenseType.transport;
      }
      return true;
    }).toList();
  }

  void _onCategoryTap(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onAddExpense() {
    Navigator.pushNamed(context, '/add_expense');
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    final transactions = _filteredTransactions(store.activeTripTransactions);

    return Scaffold(
      backgroundColor: context.appColors.scaffoldBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            // Budget header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Icon(
                    Icons.explore_outlined,
                    color: context.appColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Voyage',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  ClipOval(
                    child: Image.network(
                      store.profile.avatarUrl,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 36,
                          height: 36,
                          color: context.appColors.iconBgBlue,
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: context.appColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (store.activeTrip == null)
              // Empty trip message
              Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.appColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Create a trip before tracking expenses.',
                    style: TextStyle(color: context.appColors.textSecondary),
                  ),
                ),
              )
            else ...[
              // Budget summary
              BudgetCard(budget: store.activeBudget),
              // Expense filters
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 0, 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryChip(
                        label: 'All Expenses',
                        icon: Icons.grid_view_rounded,
                        isSelected: _selectedCategory == 'All',
                        onTap: () => _onCategoryTap('All'),
                      ),
                      CategoryChip(
                        label: 'Dining',
                        icon: Icons.restaurant,
                        isSelected: _selectedCategory == 'Dining',
                        onTap: () => _onCategoryTap('Dining'),
                      ),
                      CategoryChip(
                        label: 'Transit',
                        icon: Icons.directions_bus_filled_outlined,
                        isSelected: _selectedCategory == 'Transit',
                        onTap: () => _onCategoryTap('Transit'),
                      ),
                    ],
                  ),
                ),
              ),
              // Recent transactions
              Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Text(
                  'RECENT TRANSACTIONS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: context.appColors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              if (transactions.isEmpty)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No expenses yet.',
                    style: TextStyle(color: context.appColors.textSecondary),
                  ),
                )
              else
                ...transactions.map((transaction) {
                  return TransactionItem(transaction: transaction);
                }),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddExpense,
        backgroundColor: context.appColors.accent,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: const MyBottomNavBar(selectedIndex: 1),
    );
  }
}
