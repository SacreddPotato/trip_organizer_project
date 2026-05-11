import 'package:trip_organizer_project/data/models/trip_model.dart';
import 'package:trip_organizer_project/data/models/user_model.dart';
import 'package:trip_organizer_project/data/models/user_preferences_model.dart';

/// Manages user profile data and preferences.
class ProfileService {
  final List<User> _users = [];
  final List<UserPreferences> _preferences = [];

  /// Updates mutable fields on a user profile.
  void updateProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) {
    final user = _users.firstWhere(
      (u) => u.id == userId,
      orElse: () => throw StateError('User not found: $userId'),
    );
    // User fields are final so we rebuild — replace user in list
    final updated = User(
      id: user.id,
      fullName: fullName ?? user.fullName,
      email: user.email,
      avatarUrl: avatarUrl ?? user.avatarUrl,
      createdAt: user.createdAt,
    );
    final index = _users.indexWhere((u) => u.id == userId);
    _users[index] = updated;
  }

  /// Updates the preferences for a user (mutable fields updated in-place).
  void updatePreferences({
    required String userId,
    String? currencyCode,
    bool? pushNotificationsEnabled,
    bool? darkModeEnabled,
  }) {
    final prefs = _preferences.firstWhere(
      (p) => p.userId == userId,
      orElse: () => throw StateError('Preferences not found for user: $userId'),
    );
    if (currencyCode != null) prefs.currencyCode = currencyCode;
    if (pushNotificationsEnabled != null) {
      prefs.pushNotificationsEnabled = pushNotificationsEnabled;
    }
    if (darkModeEnabled != null) prefs.darkModeEnabled = darkModeEnabled;
  }

  /// Returns travel statistics for a user across all their trips.
  /// [allTrips] — pass the full list from TripService.
  Map<String, dynamic> getTravelStats({
    required String userId,
    required List<Trip> allTrips,
  }) {
    final userTrips = allTrips.where((t) => t.ownerId == userId).toList();

    final completed = userTrips
        .where((t) => t.status.name == 'completed')
        .length;

    final upcoming = userTrips
        .where((t) => t.startDate.isAfter(DateTime.now()))
        .length;

    final countriesVisited = <String>{};
    // Placeholder: would pull from Destination list in full implementation
    // countriesVisited = destinations.where(...).map((d) => d.country).toSet();

    return {
      'totalTrips': userTrips.length,
      'completedTrips': completed,
      'upcomingTrips': upcoming,
      'countriesVisited': countriesVisited.length,
    };
  }

  /// Registers a new user (used during sign-up).
  User registerUser({
    required String id,
    required String fullName,
    required String email,
    String? avatarUrl,
  }) {
    final user = User(
      id: id,
      fullName: fullName,
      email: email,
      avatarUrl: avatarUrl,
      createdAt: DateTime.now(),
    );
    _users.add(user);

    // Auto-create default preferences
    _preferences.add(UserPreferences(
      id: '${id}_prefs',
      userId: id,
    ));

    return user;
  }

  /// Returns preferences for a user, or null if not set up yet.
  UserPreferences? getPreferences(String userId) {
    try {
      return _preferences.firstWhere((p) => p.userId == userId);
    } catch (_) {
      return null;
    }
  }
}
