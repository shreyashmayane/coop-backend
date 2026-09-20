import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadHistory();
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.onSurface,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: provider.historyLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primary))
            : TabBarView(
                controller: _tabCtrl,
                children: [
                  _BookingList(bookings: provider.upcomingBookings),
                  _BookingList(bookings: provider.pastBookings),
                ],
              ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  const _BookingList({required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_rounded,
                size: 64, color: AppTheme.onSurface),
            const SizedBox(height: 16),
            Text('No bookings here',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: bookings.length,
      itemBuilder: (ctx, i) => _BookingTile(booking: bookings[i]),
    );
  }
}

class _BookingTile extends StatelessWidget {
  final BookingModel booking;
  const _BookingTile({required this.booking});

  Color _statusColor(BookingStatus s) {
    switch (s) {
      case BookingStatus.requested:  return AppTheme.warning;
      case BookingStatus.accepted:   return AppTheme.accent;
      case BookingStatus.inProgress: return AppTheme.primary;
      case BookingStatus.completed:  return AppTheme.success;
      case BookingStatus.cancelled:  return AppTheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(booking.status);
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.divider),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.surfaceLight,
                child: Text(
                  booking.workerName[0].toUpperCase(),
                  style: const TextStyle(
                      color: AppTheme.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.workerName,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(booking.serviceType,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Text(
                  booking.status.label,
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(Icons.schedule_rounded,
                  size: 14, color: AppTheme.onSurface),
              const SizedBox(width: 6),
              Text(
                '${booking.scheduledAt.day}/${booking.scheduledAt.month}/${booking.scheduledAt.year}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              if (booking.amountPaid != null)
                Text(
                  '₹${booking.amountPaid!.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: AppTheme.success, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          if (booking.status == BookingStatus.completed &&
              booking.paymentStatus == PaymentStatus.pending)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.payment),
                icon: const Icon(Icons.payment_rounded, size: 16),
                label: const Text('Pay Now'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  side: const BorderSide(color: AppTheme.primary),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
