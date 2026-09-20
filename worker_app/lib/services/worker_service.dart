import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'api_client.dart';

class WorkerService {
  final Dio _dio = ApiClient.instance.dio;

  Future<bool> toggleStatus(bool isAvailable) async {
    try {
      final res = await _dio.patch(ApiConfig.workerStatus, data: {'is_available': isAvailable});
      return res.data['worker']['is_available'] as bool;
    } catch (e) {
      throw ApiException('Failed to update availability');
    }
  }
}
