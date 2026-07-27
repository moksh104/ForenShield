import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../storage/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});
