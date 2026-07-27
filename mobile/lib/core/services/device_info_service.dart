import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Standardized representation of device-specific details.
class DeviceDetails {
  final String deviceId;
  final String model;
  final String osVersion;
  final String platform;

  const DeviceDetails({
    required this.deviceId,
    required this.model,
    required this.osVersion,
    required this.platform,
  });
}

/// Interface for retrieving device identity and app installation context.
abstract class DeviceInfoService {
  /// Fetches hardware and OS details.
  Future<DeviceDetails> getDeviceDetails();

  /// Fetches the current application version (e.g., '1.0.0').
  Future<String> getAppVersion();
}

/// Default mock implementation for architecture stability.
class DefaultDeviceInfoService implements DeviceInfoService {
  @override
  Future<DeviceDetails> getDeviceDetails() async {
    return const DeviceDetails(
      deviceId: 'unknown',
      model: 'unknown',
      osVersion: 'unknown',
      platform: 'unknown',
    );
  }

  @override
  Future<String> getAppVersion() async {
    return '1.0.0';
  }
}

/// Riverpod provider for dependency injection.
final deviceInfoServiceProvider = Provider<DeviceInfoService>((ref) {
  return DefaultDeviceInfoService();
});
