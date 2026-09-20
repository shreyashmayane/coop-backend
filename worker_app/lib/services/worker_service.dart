import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'api_client.dart';

class WorkerService {
  final Dio _dio = ApiClient.instance.dio;

  Future<bool> toggleStatus(bool isAvailable) async {
    try {
      await _dio.put('/workers/status', data: {
        'status': isAvailable ? 'active' : 'offline',
      });
      return isAvailable;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<bool> getWorkerAvailability(String id) async {
    try {
      final res = await _dio.get('/workers/$id');
      return res.data['isAvailable'] == true;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
