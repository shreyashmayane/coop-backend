import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/worker_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/main_screen.dart';

void main() {
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
            initialRoute: auth.isAuthenticated ? AppRoutes.home : AppRoutes.login,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}


