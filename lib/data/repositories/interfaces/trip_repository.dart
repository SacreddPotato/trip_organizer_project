import 'package:trip_organizer_project/data/models/transaction_model.dart';
import 'package:trip_organizer_project/data/models/trip_model.dart';

abstract class TripRepository {
  Future<List<Trip>> fetchTrips(String uid);
  Future<String> createTrip(String uid, Map<String, dynamic> data);
  Future<List<Transaction>> fetchTransactions(String uid, String tripId);
  Future<String> addTransaction(String uid, String tripId, Map<String, dynamic> data);
}
