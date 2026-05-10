import 'package:flutter/foundation.dart';
import 'package:trip_organizer_project/core/errors/app_exception.dart';
import 'package:trip_organizer_project/data/models/budget_model.dart';
import 'package:trip_organizer_project/data/models/popular_destination_model.dart';
import 'package:trip_organizer_project/data/models/transaction_model.dart';
import 'package:trip_organizer_project/data/models/trip_model.dart';
import 'package:trip_organizer_project/data/models/user_profile_model.dart';
import 'package:trip_organizer_project/data/repositories/interfaces/trip_repository.dart';
import 'package:trip_organizer_project/data/repositories/interfaces/user_repository.dart';

class AppStore extends ChangeNotifier {
  AppStore({
    required TripRepository tripRepository,
    required UserRepository userRepository,
  })  : _tripRepository = tripRepository,
        _userRepository = userRepository;

  final TripRepository _tripRepository;
  final UserRepository _userRepository;

  String? _currentUid;

  UserProfile profile = const UserProfile(
    name: '',
    email: '',
    avatarUrl: '',
  );
  UserPreferences preferences = const UserPreferences(darkModeEnabled: false);
  List<Trip> trips = [];
  List<Transaction> transactions = [];
  String? activeTripId;
  bool isLoaded = false;
  String? errorMessage;

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

  Future<void> load(String uid, {String? fallbackName, String? fallbackEmail}) async {
    _currentUid = uid;
    isLoaded = false;
    notifyListeners();

    try {
      final userDoc = await _userRepository.fetchUserDocument(uid);
      if (userDoc != null) {
        profile = UserProfile.fromJson(userDoc);
        preferences = UserPreferences.fromJson(userDoc);
        activeTripId = userDoc['activeTripId'] as String?;
      } else if (fallbackName != null || fallbackEmail != null) {
        final name = fallbackName ?? '';
        final email = fallbackEmail ?? '';
        await _userRepository.saveProfile(uid, {'name': name, 'email': email, 'avatarUrl': ''});
        profile = UserProfile(name: name, email: email, avatarUrl: '');
      }

      trips = await _tripRepository.fetchTrips(uid);

      if (activeTripId != null) {
        transactions = await _tripRepository.fetchTransactions(uid, activeTripId!);
      }
    } on AppException catch (e) {
      errorMessage = e.userMessage;
    }

    isLoaded = true;
    notifyListeners();
  }

  void reset() {
    _currentUid = null;
    trips = [];
    transactions = [];
    activeTripId = null;
    profile = const UserProfile(name: '', email: '', avatarUrl: '');
    preferences = const UserPreferences(darkModeEnabled: false);
    isLoaded = false;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> createTrip({
    required String destination,
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required double budget,
  }) async {
    final uid = _currentUid;
    if (uid == null) return;
    errorMessage = null;

    try {
      final tempTrip = Trip(
        id: '',
        destination: destination,
        title: title,
        startDate: startDate,
        endDate: endDate,
        budget: budget,
      );

      final docId = await _tripRepository.createTrip(uid, tempTrip.toFirestoreMap());
      final trip = Trip(
        id: docId,
        destination: destination,
        title: title,
        startDate: startDate,
        endDate: endDate,
        budget: budget,
      );

      trips = [...trips, trip];
      activeTripId = trip.id;
      transactions = [];

      await _userRepository.saveActiveTripId(uid, trip.id);
    } on AppException catch (e) {
      errorMessage = e.userMessage;
    }

    notifyListeners();
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required ExpenseType expenseType,
    required TransactionCategory category,
    required DateTime date,
  }) async {
    final uid = _currentUid;
    final trip = activeTrip;
    if (uid == null || trip == null) return;
    errorMessage = null;

    try {
      final tempTx = Transaction(
        id: '',
        tripId: trip.id,
        title: title,
        amount: amount,
        date: date,
        expenseType: expenseType,
        category: category,
        iconAsset: expenseType.name,
      );

      final docId = await _tripRepository.addTransaction(
        uid,
        trip.id,
        tempTx.toFirestoreMap(),
      );

      final tx = Transaction(
        id: docId,
        tripId: trip.id,
        title: title,
        amount: amount,
        date: date,
        expenseType: expenseType,
        category: category,
        iconAsset: expenseType.name,
      );

      transactions = [...transactions, tx];
    } on AppException catch (e) {
      errorMessage = e.userMessage;
    }

    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String avatarUrl,
  }) async {
    final uid = _currentUid;
    if (uid == null) return;
    errorMessage = null;

    try {
      await _userRepository.saveProfile(uid, {
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
      });
      profile = UserProfile(name: name, email: email, avatarUrl: avatarUrl);
    } on AppException catch (e) {
      errorMessage = e.userMessage;
    }

    notifyListeners();
  }

  Future<void> updatePreferences({bool? darkModeEnabled}) async {
    final uid = _currentUid;
    if (uid == null) return;
    errorMessage = null;

    final updated = UserPreferences(
      darkModeEnabled: darkModeEnabled ?? preferences.darkModeEnabled,
    );

    try {
      await _userRepository.savePreferences(uid, updated.toJson());
      preferences = updated;
    } on AppException catch (e) {
      errorMessage = e.userMessage;
    }

    notifyListeners();
  }
}
