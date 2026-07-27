import 'dart:convert';
import '../../../core/storage/storage_service.dart';
import '../models/feature_model.dart';

/// Defines the contract for fetching and saving local data (cache/persistence).
abstract interface class FeatureLocalDataSource {
  Future<List<FeatureModel>?> getCachedFeatures();
  Future<void> cacheFeatures(List<FeatureModel> features);
  Future<void> clearCache();
}

/// Implementation using SharedPreferences via StorageService.
class FeatureLocalDataSourceImpl implements FeatureLocalDataSource {
  final StorageService storage;

  static const String _cacheKey = 'cached_features';

  FeatureLocalDataSourceImpl(this.storage);

  @override
  Future<List<FeatureModel>?> getCachedFeatures() async {
    final cachedData = await storage.read(_cacheKey);
    if (cachedData != null) {
      final List decoded = jsonDecode(cachedData) as List;
      return decoded
          .map((json) => FeatureModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  @override
  Future<void> cacheFeatures(List<FeatureModel> features) async {
    final encoded = jsonEncode(features.map((f) => f.toJson()).toList());
    await storage.write(_cacheKey, encoded);
  }

  @override
  Future<void> clearCache() async {
    await storage.delete(_cacheKey);
  }
}
