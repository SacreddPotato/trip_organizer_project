import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trip_organizer_project/core/errors/app_exception.dart';
import 'package:trip_organizer_project/data/repositories/interfaces/user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository() : _db = FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  @override
  Future<Map<String, dynamic>?> fetchUserDocument(String uid) async {
    try {
      final snapshot = await _userDoc(uid).get();
      return snapshot.data();
    } on FirebaseException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> saveProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _userDoc(uid).set(data, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> savePreferences(String uid, Map<String, dynamic> data) async {
    try {
      await _userDoc(uid).set(data, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> saveActiveTripId(String uid, String? tripId) async {
    try {
      await _userDoc(uid).set({'activeTripId': tripId}, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw _mapError(e);
    }
  }

  AppException _mapError(FirebaseException e) {
    if (e.code == 'unavailable' || e.code == 'network-request-failed') {
      return const NetworkException();
    }
    return const UnknownException();
  }
}
