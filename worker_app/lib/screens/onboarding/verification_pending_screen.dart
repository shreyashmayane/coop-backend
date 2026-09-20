import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';

class VerificationPendingScreen extends StatelessWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_top, size: 80, color: AppTheme.primary),
              const SizedBox(height: AppTheme.spacingLg),
              Text(
                'Verification Pending',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                'Your documents have been submitted to your cooperative society. You will be notified once your profile is approved.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXl),
              OutlinedButton(
                onPressed: () {
                  // For MVP, we will allow them to skip directly to home
                  // In a real app, this wouldn't be allowed until backend changes status.
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
                child: const Text('Refresh Status (Mock Bypass)'),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                child: const Text('Log Out'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
