abstract class UserRepository {
  Future<Map<String, dynamic>?> fetchUserDocument(String uid);
  Future<void> saveProfile(String uid, Map<String, dynamic> data);
  Future<void> savePreferences(String uid, Map<String, dynamic> data);
  Future<void> saveActiveTripId(String uid, String? tripId);
}
