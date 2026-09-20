import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/service_category_model.dart';
import '../models/worker_model.dart';
import 'api_client.dart';

class WorkerService {
  final Dio _dio = ApiClient.instance.dio;

  /// Fetch service categories (falls back to mock if backend unreachable).
  Future<List<ServiceCategoryModel>> getCategories() async {
    try {
      final res = await _dio.get(ApiConfig.categories);
      final list = res.data as List<dynamic>;
      return list
          .map((e) => ServiceCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      // Return mock data so UI works without backend
      return ServiceCategoryModel.mockList();
    }
  }

  /// Fetch geo-matched workers for a service type.
  Future<List<WorkerModel>> getNearbyWorkers({
    required double lat,
    required double lng,
    required String serviceType,
  }) async {
    try {
      final res = await _dio.get(
        ApiConfig.nearbyWorkers,
        queryParameters: {
          'lat': lat,
          'lng': lng,
          'serviceType': serviceType,
        },
      );
      final list = res.data as List<dynamic>;
      return list
          .map((e) => WorkerModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      // Return mock data so UI works without backend
      return WorkerModel.mockList(serviceType);
    }
  }

  /// Fetch a single worker's full profile.
  Future<WorkerModel?> getWorkerById(String id, String serviceType) async {
    try {
      final res = await _dio.get(ApiConfig.workerById(id));
      return WorkerModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException {
      // Fall back to finding in mock list
      return WorkerModel.mockList(serviceType)
          .cast<WorkerModel?>()
          .firstWhere((w) => w?.id == id, orElse: () => null);
    }
  }
}
