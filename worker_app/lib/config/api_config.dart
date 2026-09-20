class ApiConfig {
  // Update this when your network/host changes.
  static const String baseUrl = 'https://coop-backend-ssdy.onrender.com/api';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  static const String tokenKey = 'auth_token';
  static const String userKey = 'auth_user';

  // Worker specific endpoints
  static const String workerStatus = '/workers/status';
  static const String workerBookings = '/workers/bookings';
  static String updateBookingStatus(String id) => '/workers/bookings/$id/status';
}
