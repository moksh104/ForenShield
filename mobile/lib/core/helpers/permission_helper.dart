/// High-level permissions orchestrator.
class PermissionHelper {
  PermissionHelper._();

  /// Requests camera permission. (Stubbed for future permission_handler integration).
  static Future<bool> requestCamera() async {
    return true; // Stub
  }

  /// Requests storage permission.
  static Future<bool> requestStorage() async {
    return true; // Stub
  }
}
