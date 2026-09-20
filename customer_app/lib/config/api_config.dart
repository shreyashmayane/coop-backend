/// API Configuration — Single source of truth for backend URL and keys.
/// Change [baseUrl] here when switching networks (hotspot IP, Railway URL, etc.)
class ApiConfig {
  ApiConfig._();

  // ─── Backend Base URL ─────────────────────────────────────────────────────
  /// Update this when your network/host changes.
  static const String baseUrl = 'https://coop-backend-ssdy.onrender.com/api';

  // ─── Razorpay ─────────────────────────────────────────────────────────────
  /// Replace with your Razorpay TEST key from https://dashboard.razorpay.com
  static const String razorpayKey = 'rzp_test_YOUR_KEY_HERE';

  // ─── Auth Endpoints ───────────────────────────────────────────────────────
  static const String register   = '/auth/register';
  static const String login      = '/auth/login';

  // ─── Service Endpoints ────────────────────────────────────────────────────
  static const String categories = '/services/categories';
  static const String nearbyWorkers = '/workers/nearby';
  static String workerById(String id) => '/workers/$id';

  // ─── Booking Endpoints ────────────────────────────────────────────────────
  static const String createBooking = '/bookings';
  static String bookingById(String id) => '/bookings/$id';
  static String cancelBooking(String id) => '/bookings/$id/cancel';
  static String rateBooking(String id) => '/bookings/$id/rate';
  static const String customerBookings = '/customer/bookings';

  // ─── Profile Endpoints ────────────────────────────────────────────────────
  static const String customerProfile = '/customer/profile';

  // ─── Payment Endpoints ────────────────────────────────────────────────────
  static const String createOrder   = '/payments/create-order';
  static const String verifyPayment = '/payments/verify';

  // ─── Local Storage Keys ───────────────────────────────────────────────────
  static const String tokenKey   = 'auth_token';
  static const String userKey    = 'user_data';
  static const String langKey    = 'app_locale';
}
