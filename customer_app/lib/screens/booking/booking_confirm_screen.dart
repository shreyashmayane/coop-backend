import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/custom_button.dart';

class BookingConfirmScreen extends StatelessWidget {
  const BookingConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final worker = booking.pendingWorker;
    final dt = booking.selectedDateTime;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              // ── Summary card ────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(color: AppTheme.divider),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Worker
                    _Row(
                      icon: Icons.person_rounded,
                      label: 'Worker',
                      value: worker?.name ?? 'N/A',
                    ),
                    const Divider(height: 24),
                    _Row(
                      icon: Icons.build_rounded,
                      label: 'Service',
                      value: worker?.serviceType ?? 'N/A',
                    ),
                    const Divider(height: 24),
                    _Row(
                      icon: Icons.schedule_rounded,
                      label: booking.isEmergency ? 'Mode' : 'Scheduled',
                      value: booking.isEmergency
                          ? '⚡ Emergency (ASAP)'
                          : dt != null
                              ? '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
                              : 'N/A',
                    ),
                    const Divider(height: 24),
                    _Row(
                      icon: Icons.location_on_rounded,
                      label: 'Address',
                      value: booking.selectedAddress,
                    ),
                    const Divider(height: 24),
                    _Row(
                      icon: Icons.currency_rupee,
                      label: 'Est. Rate',
                      value: '₹${worker?.hourlyRate.toInt() ?? 0}/hr',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              // ── Note ────────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  border:
                      Border.all(color: AppTheme.primary.withOpacity(0.2)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: AppTheme.primary, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Final amount may vary based on actual hours worked. Payment is collected after job completion.',
                        style: TextStyle(
                            color: AppTheme.primary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // ── Buttons ─────────────────────────────────────────────────
              CustomButton(
                label: 'Confirm Booking',
                gradient: true,
                loading: booking.loading,
                onPressed: () async {
                  final ok = await context
                      .read<BookingProvider>()
                      .confirmBooking();
                  if (ok && context.mounted) {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.bookingStatus);
                  }
                },
              ),
              const SizedBox(height: AppTheme.spacingMd),
              CustomButton(
                label: 'Edit Booking',
                outlined: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _Row({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppTheme.onSurface, fontSize: 12)),
            const SizedBox(height: 2),
            Text(value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
