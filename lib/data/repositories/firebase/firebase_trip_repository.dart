import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:trip_organizer_project/core/errors/app_exception.dart';
import 'package:trip_organizer_project/data/models/transaction_model.dart';
import 'package:trip_organizer_project/data/models/trip_model.dart';
import 'package:trip_organizer_project/data/repositories/interfaces/trip_repository.dart';

class FirebaseTripRepository implements TripRepository {
  FirebaseTripRepository() : _db = fs.FirebaseFirestore.instance;

  final fs.FirebaseFirestore _db;

  fs.CollectionReference<Map<String, dynamic>> _tripsRef(String uid) =>
      _db.collection('users').doc(uid).collection('trips');

  fs.CollectionReference<Map<String, dynamic>> _txRef(
    String uid,
    String tripId,
  ) =>
      _tripsRef(uid).doc(tripId).collection('transactions');

  @override
  Future<List<Trip>> fetchTrips(String uid) async {
    try {
      final snapshot = await _tripsRef(uid).get();
      return snapshot.docs.map((doc) {
        return Trip.fromJson({'id': doc.id, ...doc.data()});
      }).toList();
    } on fs.FirebaseException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<String> createTrip(String uid, Map<String, dynamic> data) async {
    try {
      final ref = await _tripsRef(uid).add(data);
      return ref.id;
    } on fs.FirebaseException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<List<Transaction>> fetchTransactions(
    String uid,
    String tripId,
  ) async {
    try {
      final snapshot = await _txRef(uid, tripId).get();
      return snapshot.docs.map((doc) {
        return Transaction.fromJson({'id': doc.id, ...doc.data()});
      }).toList();
    } on fs.FirebaseException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<String> addTransaction(
    String uid,
    String tripId,
    Map<String, dynamic> data,
  ) async {
    try {
      final ref = await _txRef(uid, tripId).add(data);
      return ref.id;
    } on fs.FirebaseException catch (e) {
      throw _mapError(e);
    }
  }

  AppException _mapError(fs.FirebaseException e) {
    if (e.code == 'unavailable' || e.code == 'network-request-failed') {
      return const NetworkException();
    }
    return const UnknownException();
  }
}
