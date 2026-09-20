import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

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
      body: provider.loading
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
                                      'Booking #${booking.id.substring(0, 8)}',
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
    );
  }
}
