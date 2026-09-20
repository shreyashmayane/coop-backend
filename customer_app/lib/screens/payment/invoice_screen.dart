import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/custom_button.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>().activeBooking;
    final amount =
        context.watch<BookingProvider>().pendingWorker?.hourlyRate ?? 350;
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Receipt'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              // ── Success animation ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: AppTheme.success, size: 72),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text('Payment Successful!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.success)),
              const SizedBox(height: 4),
              Text(
                '₹${amount.toStringAsFixed(0)} paid',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppTheme.spacingXl),
              // ── Invoice card ────────────────────────────────────────────
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Invoice #',
                            style: TextStyle(color: AppTheme.onSurface)),
                        Text(
                          'INV-${now.millisecondsSinceEpoch.toString().substring(7)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _InvRow(
                        label: 'Worker',
                        value: booking?.workerName ?? 'N/A'),
                    _InvRow(
                        label: 'Service',
                        value: booking?.serviceType ?? 'N/A'),
                    _InvRow(
                        label: 'Address',
                        value: booking?.address ?? 'N/A'),
                    _InvRow(
                        label: 'Date',
                        value:
                            '${now.day}/${now.month}/${now.year}'),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Paid',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '₹${amount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppTheme.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Status',
                            style: TextStyle(color: AppTheme.onSurface)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                          ),
                          child: const Text('PAID',
                              style: TextStyle(
                                  color: AppTheme.success,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // ── Rate button ─────────────────────────────────────────────
              CustomButton(
                label: 'Rate Your Experience',
                gradient: true,
                icon: Icons.star_rounded,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.rating),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              CustomButton(
                label: 'Back to Home',
                outlined: true,
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil(
                        AppRoutes.home, (r) => false),
              ),
              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvRow extends StatelessWidget {
  final String label;
  final String value;
  const _InvRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AppTheme.onSurface, fontSize: 13)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
