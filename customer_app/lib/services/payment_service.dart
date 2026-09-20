import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'api_client.dart';

// Razorpay stub types for web compatibility
class PaymentSuccessResponse {
  final String? paymentId;
  final String? orderId;
  final String? signature;
  PaymentSuccessResponse({this.paymentId, this.orderId, this.signature});
}
class PaymentFailureResponse {
  final String? message;
  PaymentFailureResponse({this.message});
}
class ExternalWalletResponse {
  final String? walletName;
  ExternalWalletResponse({this.walletName});
}

class PaymentService {
  final Dio _dio = ApiClient.instance.dio;

  /// Create a Razorpay order on the backend.
  Future<Map<String, dynamic>> createOrder({
    required String bookingId,
    required double amount, // in INR
  }) async {
    try {
      final res = await _dio.post(ApiConfig.createOrder, data: {
        'bookingId': bookingId,
        'amount': (amount * 100).toInt(), // Razorpay uses paise
      });
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Verify payment signature on the backend.
  Future<void> verifyPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    required String bookingId,
  }) async {
    try {
      await _dio.post(ApiConfig.verifyPayment, data: {
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_order_id': razorpayOrderId,
        'razorpay_signature': razorpaySignature,
        'bookingId': bookingId,
      });
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  // NOTE: Razorpay SDK is mobile-only. On web, this shows a snackbar.
  // When running on Android, uncomment razorpay_flutter in pubspec.yaml
  // and restore the full Razorpay implementation.
  void openCheckout({
    required String orderId,
    required double amount,
    required String customerName,
    required String customerPhone,
    required void Function(PaymentSuccessResponse) onSuccess,
    required void Function(PaymentFailureResponse) onFailure,
    required void Function(ExternalWalletResponse) onWallet,
  }) {
    // Simulate success for web/UI testing
    Future.delayed(const Duration(seconds: 2), () {
      onSuccess(PaymentSuccessResponse(
        paymentId: 'pay_test_${DateTime.now().millisecondsSinceEpoch}',
        orderId: orderId,
        signature: 'test_signature',
      ));
    });
  }

  void dispose() {}
}
