import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/models/settings_model.dart';
import '../../services/settings_api_service.dart';

final settingsApiServiceProvider = Provider<SettingsApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SettingsApiService(apiClient);
});

final deviceSessionsProvider =
    FutureProvider.autoDispose<List<DeviceSessionModel>>((ref) async {
      final service = ref.watch(settingsApiServiceProvider);
      return await service.getDevices();
    });

final revokeDeviceProvider = FutureProvider.family.autoDispose<void, String>((
  ref,
  sessionId,
) async {
  final service = ref.watch(settingsApiServiceProvider);
  await service.revokeDevice(sessionId);
  // Invalidate to refresh the list after revocation
  ref.invalidate(deviceSessionsProvider);
});
