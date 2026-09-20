import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/booking_model.dart';
import 'api_client.dart';

class BookingService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<BookingModel>> getWorkerBookings() async {
    try {
      final res = await _dio.get(ApiConfig.workerBookings);
      final list = res.data as List<dynamic>;
      return list.map((e) => BookingModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ApiException('Error: $e');
    }
  }

  Future<void> updateBookingStatus(String id, String status) async {
    try {
      await _dio.patch(ApiConfig.updateBookingStatus(id), data: {'status': status});
    } catch (e) {
      throw ApiException('Failed to update status');
    }
  }
}
