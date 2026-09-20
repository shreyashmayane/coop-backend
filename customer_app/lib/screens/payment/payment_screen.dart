import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/booking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/payment_service.dart';
import '../../widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  Future<void> _initiatePayment() async {
    final booking = context.read<BookingProvider>().activeBooking;
    final user = context.read<AuthProvider>().user;
    if (booking == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final amount =
          (context.read<BookingProvider>().pendingWorker?.hourlyRate ?? 350);
      // Create order on backend (falls back gracefully if backend unavailable)
      String orderId = 'order_mock_${DateTime.now().millisecondsSinceEpoch}';
      try {
        final order = await _paymentService.createOrder(
          bookingId: booking.id,
          amount: amount,
        );
        orderId = order['id'] ?? orderId;
      } catch (_) {
        // Use mock order ID if backend not reachable
      }

      _paymentService.openCheckout(
        orderId: orderId,
        amount: amount,
        customerName: user?.name ?? 'Customer',
        customerPhone: user?.phone ?? '',
        onSuccess: _onSuccess,
        onFailure: _onFailure,
        onWallet: (e) {},
      );
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _onSuccess(PaymentSuccessResponse res) async {
    setState(() => _loading = false);
    final booking = context.read<BookingProvider>().activeBooking;
    if (booking == null) return;

    // Verify on backend (best-effort)
    try {
      await _paymentService.verifyPayment(
        razorpayPaymentId: res.paymentId ?? '',
        razorpayOrderId: res.orderId ?? '',
        razorpaySignature: res.signature ?? '',
        bookingId: booking.id,
      );
    } catch (_) {}

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.invoice);
    }
  }

  void _onFailure(PaymentFailureResponse res) {
    setState(() {
      _loading = false;
      _error = res.message ?? 'Payment failed. Please try again.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final amount =
        context.watch<BookingProvider>().pendingWorker?.hourlyRate ?? 350;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              // ── Amount card ─────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacingXl),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                  boxShadow: AppTheme.primaryShadow,
                ),
                child: Column(
                  children: [
                    const Icon(Icons.payment_rounded,
                        color: Colors.white60, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      '₹${amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Total Amount',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              // ── Payment methods ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Accepted Methods',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    const _PaymentMethod(
                        icon: Icons.credit_card_rounded, label: 'Credit / Debit Card'),
                    const _PaymentMethod(
                        icon: Icons.account_balance_rounded, label: 'Net Banking'),
                    const _PaymentMethod(
                        icon: Icons.wallet_rounded, label: 'UPI / Wallets'),
                  ],
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppTheme.spacingMd),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withOpacity(0.12),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Text(_error!,
                        style: const TextStyle(color: AppTheme.error)),
                  ),
                ),
              const Spacer(),
              // ── Test mode notice ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.science_rounded,
                        color: AppTheme.warning, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Running in TEST mode — no real charges',
                      style:
                          TextStyle(color: AppTheme.warning, fontSize: 12),
                    ),
                  ],
                ),
              ),
              CustomButton(
                label: 'Pay ₹${amount.toStringAsFixed(0)}',
                gradient: true,
                loading: _loading,
                icon: Icons.lock_rounded,
                onPressed: _initiatePayment,
              ),
              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethod extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PaymentMethod({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          const Icon(Icons.check_rounded, color: AppTheme.success, size: 16),
        ],
      ),
    );
  }
}
