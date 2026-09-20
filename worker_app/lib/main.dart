import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/worker_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/main_screen.dart';
import 'screens/onboarding/skill_selection_screen.dart';
import 'screens/onboarding/verification_pending_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WorkerApp());
}

class WorkerApp extends StatelessWidget {
  const WorkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuthStatus()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => WorkerProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.loading && auth.authState == AuthState.unknown) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }

          return MaterialApp(
            title: 'Coop Worker',
            theme: AppTheme.dark,
            home: auth.isAuthenticated ? const MainScreen() : const LoginScreen(),
            routes: {
              AppRoutes.login: (_) => const LoginScreen(),
              AppRoutes.register: (_) => const RegisterScreen(),
              AppRoutes.home: (_) => const MainScreen(),
              AppRoutes.skills: (_) => const SkillSelectionScreen(),
              AppRoutes.verification: (_) => const VerificationPendingScreen(),
            },
          );
        },
      ),
    );
  }
}


