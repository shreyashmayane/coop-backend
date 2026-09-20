import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.instance.dio;

  /// Register a new customer account.
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final res = await _dio.post(ApiConfig.register, data: {
        'name': name,
        'phone': phone,
        'password': password,
        'role': 'worker',
      });
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Login and persist JWT + user data.
  Future<UserModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final res = await _dio.post(ApiConfig.login, data: {
        'phone': phone,
        'password': password,
      });
      final data = res.data as Map<String, dynamic>;
      final token = data['token'] as String;
      final user = UserModel.fromJson(
          (data['user'] ?? data['customer']) as Map<String, dynamic>);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ApiConfig.tokenKey, token);
      await prefs.setString(ApiConfig.userKey, user.toJsonString());

      return user;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Clear stored credentials.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConfig.tokenKey);
    await prefs.remove(ApiConfig.userKey);
  }

  /// Check if a JWT is stored locally.
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiConfig.tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Load cached user from SharedPreferences.
  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(ApiConfig.userKey);
    if (raw == null) return null;
    return UserModel.fromJsonString(raw);
  }
}
