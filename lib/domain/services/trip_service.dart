import 'package:trip_organizer_project/data/models/trip_model.dart';
import 'package:trip_organizer_project/data/models/trip_member_model.dart';
import 'package:trip_organizer_project/enums/trip_enums.dart';

/// Handles all trip-level CRUD operations.
/// Currently uses in-memory storage. Replace list operations
/// with real API/database calls when the backend is ready.
class TripService {
  // In-memory store (replace with API calls later)
  final List<Trip> _trips = [];

  /// Creates a new trip and adds it to the store.
  Trip createTrip({
    required String id,
    required String ownerId,
    required String title,
    String? description,
    String? coverImageUrl,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final trip = Trip(
      id: id,
      ownerId: ownerId,
      title: title,
      description: description,
      coverImageUrl: coverImageUrl,
      startDate: startDate,
      endDate: endDate,
      createdAt: DateTime.now(),
    );
    _trips.add(trip);
    return trip;
  }

  /// Updates mutable fields on an existing trip.
  /// Throws [StateError] if the trip is not found.
  void updateTrip({
    required String tripId,
    String? title,
    String? description,
    String? coverImageUrl,
    DateTime? startDate,
    DateTime? endDate,
    TripStatus? status,
  }) {
    final trip = _getTripById(tripId);
    if (title != null) trip.title = title;
    if (description != null) trip.description = description;
    if (coverImageUrl != null) trip.coverImageUrl = coverImageUrl;
    if (startDate != null) trip.startDate = startDate;
    if (endDate != null) trip.endDate = endDate;
    if (status != null) trip.status = status;
  }

  /// Permanently deletes a trip by ID.
  void deleteTrip(String tripId) {
    _trips.removeWhere((t) => t.id == tripId);
  }

  /// Returns all trips belonging to a specific user (as owner or member).
  List<Trip> getUserTrips(String ownerId) {
    return _trips.where((t) => t.ownerId == ownerId).toList();
  }

  /// Returns a single trip by ID, or null if not found.
  Trip? getTripDetails(String tripId) {
    try {
      return _trips.firstWhere((t) => t.id == tripId);
    } catch (_) {
      return null;
    }
  }

  // Private helper — throws if trip not found
  Trip _getTripById(String tripId) {
    return _trips.firstWhere(
      (t) => t.id == tripId,
      orElse: () => throw StateError('Trip not found: $tripId'),
    );
  }
}
