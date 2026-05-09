import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/app_store.dart';
import 'package:trip_organizer_project/core/constants/app_colors.dart';
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
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _BudgetHeader(store: store)),
            if (store.activeTrip == null)
              const SliverToBoxAdapter(child: _NoTripMessage())
            else ...[
              SliverToBoxAdapter(child: BudgetCard(budget: store.activeBudget)),
              SliverToBoxAdapter(
                child: Padding(
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
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    'RECENT TRANSACTIONS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              if (transactions.isEmpty)
                const SliverToBoxAdapter(child: _NoExpensesMessage())
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return TransactionItem(transaction: transactions[index]);
                  }, childCount: transactions.length),
                ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddExpense,
        backgroundColor: AppColors.accent,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: const MyBottomNavBar(selectedIndex: 1),
    );
  }
}

class _BudgetHeader extends StatelessWidget {
  final AppStore store;

  const _BudgetHeader({required this.store});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          const Icon(
            Icons.explore_outlined,
            color: AppColors.primary,
            size: 28,
          ),
          const SizedBox(width: 8),
          const Text(
            'Voyage',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 4),
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
                  color: AppColors.iconBgBlue,
                  child: const Icon(
                    Icons.person,
                    size: 20,
                    color: AppColors.primary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NoTripMessage extends StatelessWidget {
  const _NoTripMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Create a trip before tracking expenses.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _NoExpensesMessage extends StatelessWidget {
  const _NoExpensesMessage();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'No expenses yet.',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
