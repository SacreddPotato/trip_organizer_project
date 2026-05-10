import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_organizer_project/data/models/budget_model.dart';
import 'package:trip_organizer_project/data/models/popular_destination_model.dart';
import 'package:trip_organizer_project/data/models/transaction_model.dart';
import 'package:trip_organizer_project/data/models/trip_model.dart';
import 'package:trip_organizer_project/data/models/user_profile_model.dart';

class AppStore extends ChangeNotifier {
  static const _storageKey = 'voyage_minimal_state_v1';

  UserProfile profile = const UserProfile(
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=32',
  );
  UserPreferences preferences = const UserPreferences(darkModeEnabled: false);
  List<Trip> trips = [];
  List<Transaction> transactions = [];
  final List<PopularDestination> _popularDestinations = const [
    PopularDestination(
      title: 'Kyoto, Japan',
      subtitle: 'Temples, Gardens, Culture',
      iconName: 'landscape',
    ),
    PopularDestination(
      title: 'Santorini, Greece',
      subtitle: 'Beaches, Sunsets, Food',
      iconName: 'beach',
    ),
    PopularDestination(
      title: 'Rome, Italy',
      subtitle: 'History, Art, Architecture',
      iconName: 'history',
    ),
    PopularDestination(
      title: 'Bali, Indonesia',
      subtitle: 'Nature, Relaxation, Temples',
      iconName: 'nature',
    ),
  ];
  String? activeTripId;
  bool isLoaded = false;

  List<PopularDestination> get popularDestinations => _popularDestinations;

  Trip? get activeTrip {
    if (trips.isEmpty) return null;
    return trips.firstWhere(
      (trip) => trip.id == activeTripId,
      orElse: () => trips.last,
    );
  }

  List<Transaction> get activeTripTransactions {
    final trip = activeTrip;
    if (trip == null) return [];
    return transactions
        .where((transaction) => transaction.tripId == trip.id)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Budget get activeBudget {
    final trip = activeTrip;
    final spent = activeTripTransactions.fold<double>(
      0,
      (total, transaction) => total + transaction.amount,
    );
    return Budget(totalBudget: trip?.budget ?? 0, spent: spent);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      _readJson(jsonDecode(raw) as Map<String, dynamic>);
    }
    isLoaded = true;
    notifyListeners();
  }

  Future<void> createTrip({
    required String destination,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
  }) async {
    final trip = Trip(
      id: _createId('trip'),
      destination: destination,
      title: title,
      startDate: startDate,
      endDate: endDate,
      budget: budget,
    );
    trips = [...trips, trip];
    activeTripId = trip.id;
    await _save();
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required ExpenseType expenseType,
    required TransactionCategory category,
    required DateTime date,
  }) async {
    final trip = activeTrip;
    if (trip == null) return;

    final transaction = Transaction(
      id: _createId('transaction'),
      tripId: trip.id,
      title: title,
      amount: amount,
      date: date,
      expenseType: expenseType,
      category: category,
      iconAsset: expenseType.name,
    );
    transactions = [...transactions, transaction];
    await _save();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String avatarUrl,
  }) async {
    profile = UserProfile(name: name, email: email, avatarUrl: avatarUrl);
    await _save();
  }

  Future<void> updatePreferences({bool? darkModeEnabled}) async {
    preferences = UserPreferences(
      darkModeEnabled: darkModeEnabled ?? preferences.darkModeEnabled,
    );
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_toJson()));
    notifyListeners();
  }

  Map<String, dynamic> _toJson() {
    return {
      'profile': profile.toJson(),
      'preferences': preferences.toJson(),
      'trips': trips.map((trip) => trip.toJson()).toList(),
      'transactions': transactions
          .map((transaction) => transaction.toJson())
          .toList(),
      'activeTripId': activeTripId,
    };
  }

  void _readJson(Map<String, dynamic> json) {
    profile = UserProfile.fromJson(json['profile'] as Map<String, dynamic>);
    preferences = UserPreferences.fromJson(
      json['preferences'] as Map<String, dynamic>,
    );
    trips = (json['trips'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(Trip.fromJson)
        .toList();
    transactions = (json['transactions'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(Transaction.fromJson)
        .toList();
    activeTripId = json['activeTripId'] as String?;
  }

  String _createId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  }
}
