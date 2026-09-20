import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';
import '../../widgets/booking_status_stepper.dart';
import '../../widgets/custom_button.dart';

class BookingStatusScreen extends StatelessWidget {
  const BookingStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>().activeBooking;

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Status')),
        body: const Center(
          child: Text('No active booking found.',
              style: TextStyle(color: AppTheme.onSurface)),
        ),
      );
    }

    final isCompleted = booking.status == BookingStatus.completed;
    final isCancelled = booking.status == BookingStatus.cancelled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Booking Status'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Booking ID ──────────────────────────────────────────────
              Text('Booking #${booking.id.substring(0, 8).toUpperCase()}',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppTheme.spacingLg),
              // ── Stepper ─────────────────────────────────────────────────
              BookingStatusStepper(currentStatus: booking.status),
              const SizedBox(height: AppTheme.spacingXl),
              // ── Worker info ─────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.surfaceLight,
                      child: Text(
                        booking.workerName[0].toUpperCase(),
                        style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.workerName,
                            style:
                                Theme.of(context).textTheme.titleMedium),
                        Text(booking.serviceType,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    const Spacer(),
                    // Call button placeholder
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.call_rounded,
                            color: AppTheme.success),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Calling feature coming soon')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // ── Actions ─────────────────────────────────────────────────
              if (isCompleted) ...[
                CustomButton(
                  label: 'Proceed to Payment',
                  gradient: true,
                  icon: Icons.payment_rounded,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.payment),
                ),
              ] else if (isCancelled) ...[
                CustomButton(
                  label: 'Back to Home',
                  outlined: true,
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.home),
                ),
              ] else ...[
                CustomButton(
                  label: 'Cancel Booking',
                  outlined: true,
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppTheme.surface,
                        title: const Text('Cancel Booking?'),
                        content: const Text(
                            'Are you sure you want to cancel this booking?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Yes, Cancel',
                                style: TextStyle(color: AppTheme.error)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && context.mounted) {
                      await context
                          .read<BookingProvider>()
                          .cancelBooking();
                      if (context.mounted) {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.home);
                      }
                    }
                  },
                ),
              ],
              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}
