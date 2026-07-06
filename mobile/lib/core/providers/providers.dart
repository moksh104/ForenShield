import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../storage/storage_service.dart';

/// Global provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Global provider for StorageService
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
