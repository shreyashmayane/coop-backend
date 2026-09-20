import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/worker_provider.dart';
import '../../config/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchBookings();
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<WorkerProvider>().fetchInitialAvailability(auth.user!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final worker = context.watch<WorkerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => provider.fetchBookings(),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd, vertical: AppTheme.spacingSm),
            color: worker.isAvailable ? AppTheme.success.withOpacity(0.1) : AppTheme.surfaceLight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.isAvailable ? 'You are Online' : 'You are Offline',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: worker.isAvailable ? AppTheme.success : AppTheme.onSurface,
                          ),
                    ),
                    Text(
                      worker.isAvailable ? 'Waiting for job requests...' : 'Go online to receive jobs',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Switch(
                  value: worker.isAvailable,
                  activeColor: AppTheme.success,
                  onChanged: worker.loading ? null : (val) => worker.toggleAvailability(val),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(child: Text(provider.error!, style: const TextStyle(color: AppTheme.error)))
                    : RefreshIndicator(
                        onRefresh: provider.fetchBookings,
                        child: provider.pendingBookings.isEmpty
                            ? ListView(
                                children: const [
                                  SizedBox(height: 100),
                                  Center(child: Text('No pending job requests.')),
                                ],
                              )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppTheme.spacingMd),
                          itemCount: provider.pendingBookings.length,
                          itemBuilder: (context, index) {
                            final booking = provider.pendingBookings[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.spacingMd),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Booking #${booking.id}',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text('Date: ${booking.scheduledAt.toString().substring(0, 10)}'),
                                    const SizedBox(height: 8),
                                    Text('Address: ${booking.address}'),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                                            onPressed: () => provider.updateStatus(booking.id, 'accepted'),
                                            child: const Text('Accept'),
                                          ),
                                        ),
                                        const SizedBox(width: AppTheme.spacingMd),
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(foregroundColor: AppTheme.error),
                                            onPressed: () => provider.updateStatus(booking.id, 'cancelled'),
                                            child: const Text('Reject'),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
