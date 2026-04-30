import 'package:flutter/material.dart';
import 'package:trip_organizer_project/core/constants/app_colors.dart';
import 'package:trip_organizer_project/data/models/budget_model.dart';
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

  final Budget _budget = const Budget(
    totalBudget: 4250.00,
    spent: 2840.50,
  );

  late final List<Transaction> _transactions;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _transactions = [
      Transaction(
        id: '1',
        title: 'Le Petit Bistro',
        amount: 42.80,
        date: DateTime(now.year, now.month, now.day, 14, 30),
        expenseType: ExpenseType.dining,
        category: TransactionCategory.personal,
        iconAsset: 'dining',
      ),
      Transaction(
        id: '2',
        title: 'Eurostar Transit',
        amount: 156.00,
        date: now.subtract(const Duration(days: 1)),
        expenseType: ExpenseType.transport,
        category: TransactionCategory.travel,
        iconAsset: 'transit',
      ),
      Transaction(
        id: '3',
        title: 'Local Artisan Market',
        amount: 89.20,
        date: DateTime(now.year, 10, 24),
        expenseType: ExpenseType.shopping,
        category: TransactionCategory.other,
        iconAsset: 'shopping',
      ),
      Transaction(
        id: '4',
        title: 'Morning Brew Co.',
        amount: 6.50,
        date: DateTime(now.year, 10, 23),
        expenseType: ExpenseType.dining,
        category: TransactionCategory.personal,
        iconAsset: 'dining',
      ),
      Transaction(
        id: '5',
        title: 'The Grand Gallery',
        amount: 35.00,
        date: DateTime(now.year, 10, 23),
        expenseType: ExpenseType.activities,
        category: TransactionCategory.travel,
        iconAsset: 'activities',
      ),
    ];
  }

  List<Transaction> get _filteredTransactions {
    if (_selectedCategory == 'All') return _transactions;
    return _transactions.where((t) {
      if (_selectedCategory == 'Dining') {
        return t.expenseType == ExpenseType.dining;
      } else if (_selectedCategory == 'Transit') {
        return t.expenseType == ExpenseType.transit ||
            t.expenseType == ExpenseType.transport;
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
    // TODO: Navigate to add expense screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
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
                      icon: const Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    ClipOval(
                      child: Image.network(
                        'https://i.pravatar.cc/150?img=32',
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
              ),
            ),
            // Budget Card
            SliverToBoxAdapter(
              child: BudgetCard(budget: _budget),
            ),
            // Category Chips
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
            // Recent Transactions Label
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
            // Transactions List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return TransactionItem(
                    transaction: _filteredTransactions[index],
                  );
                },
                childCount: _filteredTransactions.length,
              ),
            ),
            // Bottom padding for FAB
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddExpense,
        backgroundColor: AppColors.accent,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: const MyBottomNavBar(selectedIndex: 1)
    );
  }
}


