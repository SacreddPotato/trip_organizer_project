import 'package:trip_organizer_project/data/models/activity_model.dart';
import 'package:trip_organizer_project/data/models/itinerary_item_model.dart';
import 'package:trip_organizer_project/enums/trip_enums.dart';

/// Handles itinerary and activity management for a trip.
class ItineraryService {
  final List<ItineraryItem> _items = [];
  final List<Activity> _activities = [];

  /// Adds a new itinerary item to a trip.
  ItineraryItem addItineraryItem({
    required String id,
    required String tripId,
    required String title,
    String? notes,
    required DateTime startsAt,
    required DateTime endsAt,
    int? sortOrder,
  }) {
    final item = ItineraryItem(
      id: id,
      tripId: tripId,
      title: title,
      notes: notes,
      startsAt: startsAt,
      endsAt: endsAt,
      sortOrder: sortOrder ?? _items.length,
    );
    _items.add(item);
    return item;
  }

  /// Adds an Activity linked to an ItineraryItem.
  Activity addActivity({
    required String id,
    required String itineraryItemId,
    required ActivityType type,
    required String locationName,
    required double latitude,
    required double longitude,
  }) {
    final activity = Activity(
      id: id,
      itineraryItemId: itineraryItemId,
      type: type,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
    );
    _activities.add(activity);
    return activity;
  }

  /// Updates an existing itinerary item's mutable fields.
  void updateActivity({
    required String itemId,
    String? title,
    String? notes,
    DateTime? startsAt,
    DateTime? endsAt,
  }) {
    final item = _items.firstWhere(
      (i) => i.id == itemId,
      orElse: () => throw StateError('ItineraryItem not found: $itemId'),
    );
    if (title != null) item.title = title;
    if (notes != null) item.notes = notes;
    if (startsAt != null) item.startsAt = startsAt;
    if (endsAt != null) item.endsAt = endsAt;
  }

  /// Reorders the timeline by reassigning sortOrder values.
  /// [orderedIds] must contain all item IDs for the trip in the desired order.
  void reorderTimeline(List<String> orderedIds) {
    for (int i = 0; i < orderedIds.length; i++) {
      final item = _items.firstWhere((it) => it.id == orderedIds[i]);
      item.sortOrder = i;
    }
  }

  /// Marks an itinerary item as completed.
  void completeItem(String itemId) {
    final item = _items.firstWhere(
      (i) => i.id == itemId,
      orElse: () => throw StateError('ItineraryItem not found: $itemId'),
    );
    item.status = ItineraryStatus.completed;
  }

  /// Returns all items for a trip, sorted by sortOrder.
  List<ItineraryItem> getItemsForTrip(String tripId) {
    return _items
        .where((i) => i.tripId == tripId)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Returns all activities for a given itinerary item.
  List<Activity> getActivitiesForItem(String itineraryItemId) {
    return _activities
        .where((a) => a.itineraryItemId == itineraryItemId)
        .toList();
  }
}
