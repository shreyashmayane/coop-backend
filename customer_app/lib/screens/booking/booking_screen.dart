import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/booking_provider.dart';
import '../../providers/worker_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _addressCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 2));

  @override
  void initState() {
    super.initState();
    final booking = context.read<BookingProvider>();
    if (booking.isEmergency) {
      _selectedDate = DateTime.now().add(const Duration(minutes: 30));
    }
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (ctx, child) => Theme(
        data: AppTheme.dark,
        child: child!,
      ),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
      builder: (ctx, child) => Theme(
        data: AppTheme.dark,
        child: child!,
      ),
    );
    if (time == null) return;

    setState(() {
      _selectedDate = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    context.read<BookingProvider>().setDateTime(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final worker = context.watch<WorkerProvider>().selectedWorker;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Service')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Worker summary ──────────────────────────────────────────
              if (worker != null)
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
                          worker.name[0].toUpperCase(),
                          style: const TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(worker.name,
                              style:
                                  Theme.of(context).textTheme.titleMedium),
                          Text(worker.serviceType,
                              style:
                                  Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '₹${worker.hourlyRate.toInt()}/hr',
                        style: const TextStyle(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppTheme.spacingLg),
              // ── Emergency toggle ──────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Text('Emergency (ASAP)',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Switch(
                    value: booking.isEmergency,
                    onChanged: (v) {
                      context.read<BookingProvider>().setEmergency(v);
                      setState(() {
                        _selectedDate = v
                            ? DateTime.now()
                                .add(const Duration(minutes: 30))
                            : DateTime.now()
                                .add(const Duration(hours: 2));
                      });
                    },
                    activeThumbColor: AppTheme.primary,
                  ),
                ],
              ),
              if (booking.isEmergency)
                Container(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: AppTheme.warning, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Worker will arrive within ~30 minutes',
                        style: TextStyle(
                            color: AppTheme.warning, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppTheme.spacingMd),
              // ── Date/Time picker ──────────────────────────────────────
              if (!booking.isEmergency) ...[
                Text('Schedule Date & Time',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickDateTime,
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            color: AppTheme.primary, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}  ${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        const Icon(Icons.edit_rounded,
                            color: AppTheme.onSurface, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
              ],
              // ── Address ────────────────────────────────────────────────
              Text('Service Address',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Enter your full address',
                controller: _addressCtrl,
                maxLines: 3,
                prefixIcon: const Icon(Icons.location_on_rounded,
                    color: AppTheme.onSurface, size: 20),
                onChanged: (v) =>
                    context.read<BookingProvider>().setAddress(v),
              ),
              const SizedBox(height: AppTheme.spacingXl),
              // ── Continue ───────────────────────────────────────────────
              CustomButton(
                label: 'Review Booking',
                gradient: true,
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  if (_addressCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter your address')),
                    );
                    return;
                  }
                  if (worker != null) {
                    context.read<BookingProvider>().prepareBooking(
                          worker: worker,
                          dateTime: _selectedDate,
                          address: _addressCtrl.text.trim(),
                          isEmergency: booking.isEmergency,
                        );
                  }
                  Navigator.of(context)
                      .pushNamed(AppRoutes.bookingConfirm);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
