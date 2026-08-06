/// A high-level service for secure credential storage.
///
/// This is an abstraction layer for a secure storage implementation such as
/// `flutter_secure_storage`. The current application still uses the existing
/// `StorageService` for persistent storage, but this interface can be connected
/// to a secure storage implementation later without changing business logic.
abstract class SecureStorageService {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> clear();
}
