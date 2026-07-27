import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the current network connection type.
enum ConnectionType { wifi, mobile, none, unknown }

/// Interface to monitor device network connectivity status.
abstract class ConnectivityService {
  /// Checks if the device currently has an active network connection.
  Future<bool> get isConnected;

  /// Retrieves the specific type of current connection.
  Future<ConnectionType> get connectionType;

  /// A continuous stream of connectivity changes.
  Stream<ConnectionType> get onConnectivityChanged;
}

/// Default implementation providing mock connectivity data.
class DefaultConnectivityService implements ConnectivityService {
  @override
  Future<bool> get isConnected async => true;

  @override
  Future<ConnectionType> get connectionType async => ConnectionType.wifi;

  @override
  Stream<ConnectionType> get onConnectivityChanged =>
      Stream.value(ConnectionType.wifi);
}

/// Riverpod provider for dependency injection.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return DefaultConnectivityService();
});
