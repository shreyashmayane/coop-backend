import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/booking_model.dart';
import 'api_client.dart';

class BookingService {
  final Dio _dio = ApiClient.instance.dio;

  /// Create a new booking.
  Future<BookingModel> createBooking({
    required String workerId,
    required String serviceType,
    required DateTime scheduledAt,
    required String address,
    required bool isEmergency,
  }) async {
    try {
      final res = await _dio.post(ApiConfig.createBooking, data: {
        'workerId': workerId,
        'serviceType': serviceType,
        'scheduledAt': scheduledAt.toIso8601String(),
        'address': address,
        'isEmergency': isEmergency,
      });
      return BookingModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Poll booking status.
  Future<BookingModel?> getBookingStatus(String id) async {
    try {
      final res = await _dio.get(ApiConfig.bookingById(id));
      return BookingModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException {
      return null;
    }
  }

  /// Cancel a booking.
  Future<void> cancelBooking(String id) async {
    try {
      await _dio.patch(ApiConfig.cancelBooking(id));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Get customer booking history.
  Future<List<BookingModel>> getHistory() async {
    try {
      final res = await _dio.get(ApiConfig.customerBookings);
      final list = res.data as List<dynamic>;
      return list
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      return BookingModel.mockHistory();
    }
  }

  /// Submit rating and feedback after job completion.
  Future<void> submitRating({
    required String bookingId,
    required double rating,
    required String comment,
  }) async {
    try {
      await _dio.post(ApiConfig.rateBooking(bookingId), data: {
        'rating': rating,
        'comment': comment,
      });
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
