import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/api_config.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/worker_provider.dart';
import 'providers/booking_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/booking/worker_list_screen.dart';
import 'screens/booking/worker_profile_screen.dart';
import 'screens/booking/booking_screen.dart';
import 'screens/booking/booking_confirm_screen.dart';
import 'screens/booking/booking_status_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/payment/invoice_screen.dart';
import 'screens/rating/rating_screen.dart';
import 'screens/history/booking_history_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Hive init ─────────────────────────────────────────────────────────────
  await Hive.initFlutter();

  // ── Firebase init (requires google-services.json) ─────────────────────────
  // Uncomment after adding google-services.json:
  // await Firebase.initializeApp();

  // ── Read stored locale ────────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  final localeCode = prefs.getString(ApiConfig.langKey) ?? 'en';

  runApp(CoopCustomerApp(localeCode: localeCode));
}

class CoopCustomerApp extends StatelessWidget {
  final String localeCode;

  const CoopCustomerApp({super.key, required this.localeCode});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WorkerProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp(
        title: 'CoopServices',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,

        // ── Localization ─────────────────────────────────────────────────
        locale: Locale(localeCode),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('hi'),
        ],

        // ── Routes ───────────────────────────────────────────────────────
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash:         (_) => const SplashScreen(),
          AppRoutes.login:          (_) => const LoginScreen(),
          AppRoutes.register:       (_) => const RegisterScreen(),
          AppRoutes.home:           (_) => const HomeScreen(),
          AppRoutes.workerList:     (_) => const WorkerListScreen(),
          AppRoutes.workerProfile:  (_) => const WorkerProfileScreen(),
          AppRoutes.booking:        (_) => const BookingScreen(),
          AppRoutes.bookingConfirm: (_) => const BookingConfirmScreen(),
          AppRoutes.bookingStatus:  (_) => const BookingStatusScreen(),
          AppRoutes.payment:        (_) => const PaymentScreen(),
          AppRoutes.invoice:        (_) => const InvoiceScreen(),
          AppRoutes.rating:         (_) => const RatingScreen(),
          AppRoutes.history:        (_) => const BookingHistoryScreen(),
          AppRoutes.profile:        (_) => const ProfileScreen(),
        },
      ),
    );
  }
}
