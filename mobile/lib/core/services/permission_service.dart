import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Standardized permissions, abstracting away platform-specific details.
enum AppPermission { camera, location, notification, storage, microphone }

/// Standardized permission statuses.
enum AppPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
}

/// Interface for handling system permissions natively.
abstract class PermissionService {
  /// Prompts the user for a specific permission.
  Future<AppPermissionStatus> requestPermission(AppPermission permission);

  /// Checks the current status of a specific permission.
  Future<AppPermissionStatus> checkPermissionStatus(AppPermission permission);

  /// Opens the device settings page for the app.
  Future<bool> openAppSettings();
}

/// Default implementation suitable for mocking or initial development.
class DefaultPermissionService implements PermissionService {
  @override
  Future<AppPermissionStatus> requestPermission(
    AppPermission permission,
  ) async {
    return AppPermissionStatus.denied;
  }

  @override
  Future<AppPermissionStatus> checkPermissionStatus(
    AppPermission permission,
  ) async {
    return AppPermissionStatus.denied;
  }

  @override
  Future<bool> openAppSettings() async {
    return false;
  }
}

/// Riverpod provider for dependency injection.
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return DefaultPermissionService();
});
