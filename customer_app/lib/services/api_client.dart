import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

/// Dio HTTP client — JWT-injecting, error-handling, debug-logging.
class ApiClient {
  ApiClient._();
  static final ApiClient _instance = ApiClient._();
  static ApiClient get instance => _instance;

  late final Dio _dio;
  bool _initialized = false;

  Dio get dio {
    if (!_initialized) init();
    return _dio;
  }

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ));

    // ── Auth interceptor — inject Bearer token ──────────────────────────────
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(ApiConfig.tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Token expired — clear token (provider will handle redirect)
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove(ApiConfig.tokenKey);
            await prefs.remove(ApiConfig.userKey);
          }
          handler.next(e);
        },
      ),
    );

    // ── Debug logging ───────────────────────────────────────────────────────
    assert(() {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
      return true;
    }());

    _initialized = true;
  }
}

/// Friendly API exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException($statusCode): $message';

  factory ApiException.fromDio(DioException e) {
    final data = e.response?.data;
    final msg = (data is Map ? data['message'] ?? data['error'] : null) ??
        e.message ??
        'Network error. Please try again.';
    return ApiException(msg.toString(), e.response?.statusCode);
  }
}
