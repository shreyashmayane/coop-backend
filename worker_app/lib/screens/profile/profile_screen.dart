import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/worker_provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final worker = context.watch<WorkerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primary.withOpacity(0.2),
            child: const Icon(Icons.person, size: 50, color: AppTheme.primary),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            auth.user?.name ?? 'Worker Name',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Text(
            auth.user?.phone ?? 'Phone',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingXl),
          Card(
            child: SwitchListTile(
              title: const Text('Available for Work'),
              subtitle: const Text('Toggle to receive job requests'),
              value: worker.isAvailable,
              activeColor: AppTheme.success,
              onChanged: worker.loading ? null : (val) => worker.toggleAvailability(val),
            ),
          ),
        ],
      ),
    );
  }
}
