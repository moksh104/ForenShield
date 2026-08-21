import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../data/models/settings_model.dart';

class SettingsApiService {
  final ApiClient _apiClient;

  SettingsApiService(this._apiClient);

  Future<List<DeviceSessionModel>> getDevices() async {
    final response = await _apiClient.get(ApiEndpoints.settingsDevices);
    if (response.statusCode == 200) {
      final List data = response.data['devices'] ?? [];
      return data
          .map(
            (json) => DeviceSessionModel(
              id: json['id'].toString(),
              deviceName: json['device_name'] ?? 'Unknown',
              deviceType: json['platform'] ?? 'Unknown',
              ipAddress: json['ip_address'] ?? 'Unknown',
              location:
                  'Unknown Location', // GeoIP requires paid APIs, sticking to default
              lastActive: DateTime.parse(json['last_active']),
              isCurrentDevice:
                  json['is_current'] == true || json['is_current'] == 1,
            ),
          )
          .toList();
    }
    throw Exception('Failed to load devices');
  }

  Future<void> revokeDevice(String sessionId) async {
    final response = await _apiClient.post(
      ApiEndpoints.settingsRevokeDevice,
      data: {'session_id': sessionId},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to revoke device');
    }
  }

  Future<List<LoginHistoryModel>> getLoginHistory({int page = 1}) async {
    final response = await _apiClient.get(
      ApiEndpoints.settingsLoginHistory,
      queryParameters: {'page': page},
    );
    if (response.statusCode == 200) {
      final List data = response.data['history'] ?? [];
      return data
          .map(
            (json) => LoginHistoryModel(
              id: json['id'].toString(),
              ipAddress: json['ip_address'] ?? 'Unknown',
              location: 'Unknown',
              device: json['device_name'] ?? 'Unknown',
              timestamp: DateTime.parse(json['login_time']),
              isSuccessful: json['status'] == 'success',
            ),
          )
          .toList();
    }
    throw Exception('Failed to load login history');
  }

  Future<void> deleteAccount(String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.settingsDeleteAccount,
      data: {'password': password},
    );
    if (response.statusCode != 200) {
      throw Exception(response.data['error'] ?? 'Failed to delete account');
    }
  }
}
