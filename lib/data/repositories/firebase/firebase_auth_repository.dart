import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trip_organizer_project/core/errors/app_exception.dart';
import 'package:trip_organizer_project/data/repositories/interfaces/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository()
      : _auth = FirebaseAuth.instance,
        _db = FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  @override
  Stream<String?> get authStateChanges =>
      _auth.authStateChanges().map((user) => user?.uid);

  @override
  String? get currentUid => _auth.currentUser?.uid;

  @override
  String? get currentDisplayName => _auth.currentUser?.displayName;

  @override
  String? get currentEmail => _auth.currentUser?.email;

  @override
  Future<String> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      await user.updateDisplayName(fullName);
      await _db.collection('users').doc(user.uid).set({
        'name': fullName,
        'email': email,
        'avatarUrl': '',
      });
      return user.uid;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthCode(e.code));
    } catch (_) {
      throw const UnknownException();
    }
  }

  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthCode(e.code));
    } catch (_) {
      throw const UnknownException();
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _mapAuthCode(String code) => switch (code) {
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' =>
          'Invalid email or password.',
        'email-already-in-use' =>
          'An account with this email already exists.',
        'weak-password' => 'Password must be at least 6 characters.',
        'network-request-failed' => 'No internet connection.',
        'too-many-requests' =>
          'Too many attempts. Please try again later.',
        _ => 'Authentication failed. Please try again.',
      };
}
