import 'package:dio/dio.dart';
import '../models/feature_model.dart';
import '../models/feature_request.dart';
import '../../../core/network/api_client.dart';
import '../../../core/exceptions/app_exceptions.dart';

/// Defines the contract for fetching remote data.
abstract interface class FeatureRemoteDataSource {
  Future<List<FeatureModel>> getFeatures();
  Future<FeatureModel> getFeatureById(String id);
  Future<FeatureModel> createFeature(FeatureRequest request);
  Future<FeatureModel> updateFeature(String id, FeatureRequest request);
  Future<void> deleteFeature(String id);
}

/// Implementation using Dio for network calls.
class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  final ApiClient apiClient;

  FeatureRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<FeatureModel>> getFeatures() async {
    try {
      final response = await apiClient.get('/features');
      final data = response.data['data'] as List;
      return data
          .map((json) => FeatureModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException(
        e.message ?? 'Unknown network error',
        e.response?.statusCode ?? 500,
      );
    }
  }

  @override
  Future<FeatureModel> getFeatureById(String id) async {
    try {
      final response = await apiClient.get('/features/$id');
      return FeatureModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException(
        e.message ?? 'Unknown network error',
        e.response?.statusCode ?? 500,
      );
    }
  }

  @override
  Future<FeatureModel> createFeature(FeatureRequest request) async {
    try {
      final response = await apiClient.post(
        '/features',
        data: request.toJson(),
      );
      return FeatureModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException(
        e.message ?? 'Unknown network error',
        e.response?.statusCode ?? 500,
      );
    }
  }

  @override
  Future<FeatureModel> updateFeature(String id, FeatureRequest request) async {
    try {
      final response = await apiClient.put(
        '/features/$id',
        data: request.toJson(),
      );
      return FeatureModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException(
        e.message ?? 'Unknown network error',
        e.response?.statusCode ?? 500,
      );
    }
  }

  @override
  Future<void> deleteFeature(String id) async {
    try {
      await apiClient.delete('/features/$id');
    } on DioException catch (e) {
      throw ApiException(
        e.message ?? 'Unknown network error',
        e.response?.statusCode ?? 500,
      );
    }
  }
}
