abstract class AuthRepository {
  Stream<String?> get authStateChanges;
  String? get currentUid;
  String? get currentDisplayName;
  String? get currentEmail;
  Future<String> register({required String email, required String password, required String fullName});
  Future<String> signIn({required String email, required String password});
  Future<void> signOut();
}
