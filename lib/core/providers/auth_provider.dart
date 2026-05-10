import 'package:flutter/foundation.dart';
import 'package:trip_organizer_project/core/errors/app_exception.dart';
import 'package:trip_organizer_project/data/repositories/interfaces/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthRepository authRepository})
      : _authRepository = authRepository {
    _authRepository.authStateChanges.listen(_onAuthStateChanged);
  }

  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.unknown;
  String? _uid;
  String? _error;

  AuthStatus get status => _status;
  String? get uid => _uid;
  String? get error => _error;
  String? get displayName => _authRepository.currentDisplayName;
  String? get email => _authRepository.currentEmail;

  void _onAuthStateChanged(String? uid) {
    _uid = uid;
    _status = uid != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    _error = null;
    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) async {
    _error = null;
    try {
      await _authRepository.signIn(email: email, password: password);
      return true;
    } on AppException catch (e) {
      _error = e.userMessage;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({required String email, required String password, required String fullName}) async {
    _error = null;
    try {
      await _authRepository.register(email: email, password: password, fullName: fullName);
      return true;
    } on AppException catch (e) {
      _error = e.userMessage;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
