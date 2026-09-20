import 'dart:async';
import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/worker_model.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _service = BookingService();

  BookingModel? _activeBooking;
  List<BookingModel> _history = [];
  bool _loading = false;
  bool _historyLoading = false;
  String? _error;
  Timer? _pollTimer;

  // ─── Booking creation state ───────────────────────────────────────────────
  WorkerModel? _pendingWorker;
  DateTime? _selectedDateTime;
  String _selectedAddress = '';
  bool _isEmergency = false;

  BookingModel? get activeBooking => _activeBooking;
  List<BookingModel> get history => _history;
  bool get loading => _loading;
  bool get historyLoading => _historyLoading;
  String? get error => _error;
  WorkerModel? get pendingWorker => _pendingWorker;
  DateTime? get selectedDateTime => _selectedDateTime;
  String get selectedAddress => _selectedAddress;
  bool get isEmergency => _isEmergency;

  List<BookingModel> get upcomingBookings => _history
      .where((b) =>
          b.status == BookingStatus.requested ||
          b.status == BookingStatus.accepted ||
          b.status == BookingStatus.inProgress)
      .toList();

  List<BookingModel> get pastBookings => _history
      .where((b) =>
          b.status == BookingStatus.completed ||
          b.status == BookingStatus.cancelled)
      .toList();

  // ─── Setup ────────────────────────────────────────────────────────────────
  void prepareBooking({
    required WorkerModel worker,
    required DateTime dateTime,
    required String address,
    required bool isEmergency,
  }) {
    _pendingWorker = worker;
    _selectedDateTime = dateTime;
    _selectedAddress = address;
    _isEmergency = isEmergency;
    notifyListeners();
  }

  void setEmergency(bool val) {
    _isEmergency = val;
    if (val) _selectedDateTime = DateTime.now().add(const Duration(minutes: 30));
    notifyListeners();
  }

  void setDateTime(DateTime dt) {
    _selectedDateTime = dt;
    notifyListeners();
  }

  void setAddress(String addr) {
    _selectedAddress = addr;
    notifyListeners();
  }

  // ─── Create Booking ───────────────────────────────────────────────────────
  Future<bool> confirmBooking() async {
    if (_pendingWorker == null || _selectedDateTime == null) return false;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _activeBooking = await _service.createBooking(
        workerId: _pendingWorker!.id,
        serviceType: _pendingWorker!.serviceType,
        scheduledAt: _selectedDateTime!,
        address: _selectedAddress,
        isEmergency: _isEmergency,
      );
      _loading = false;
      notifyListeners();
      _startPolling(_activeBooking!.id);
      return true;
    } catch (e) {
      // Mock for demo
      _activeBooking = BookingModel(
        id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
        workerId: _pendingWorker!.id,
        workerName: _pendingWorker!.name,
        workerAvatar: _pendingWorker!.avatarUrl ?? '',
        serviceType: _pendingWorker!.serviceType,
        scheduledAt: _selectedDateTime!,
        address: _selectedAddress,
        status: BookingStatus.requested,
        paymentStatus: PaymentStatus.pending,
        isEmergency: _isEmergency,
        createdAt: DateTime.now(),
      );
      _loading = false;
      notifyListeners();
      return true;
    }
  }

  // ─── Status Polling ───────────────────────────────────────────────────────
  void _startPolling(String bookingId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final updated = await _service.getBookingStatus(bookingId);
      if (updated != null) {
        _activeBooking = updated;
        notifyListeners();
        if (updated.status == BookingStatus.completed ||
            updated.status == BookingStatus.cancelled) {
          _pollTimer?.cancel();
        }
      }
    });
  }

  void stopPolling() {
    _pollTimer?.cancel();
  }

  // ─── History ──────────────────────────────────────────────────────────────
  Future<void> loadHistory() async {
    _historyLoading = true;
    notifyListeners();
    try {
      _history = await _service.getHistory();
    } catch (_) {
      _history = BookingModel.mockHistory();
    } finally {
      _historyLoading = false;
      notifyListeners();
    }
  }

  // ─── Cancel ───────────────────────────────────────────────────────────────
  Future<void> cancelBooking() async {
    if (_activeBooking == null) return;
    await _service.cancelBooking(_activeBooking!.id);
    _activeBooking = null;
    _pollTimer?.cancel();
    notifyListeners();
  }

  // ─── Rating ───────────────────────────────────────────────────────────────
  Future<bool> submitRating(double rating, String comment) async {
    if (_activeBooking == null) return false;
    try {
      await _service.submitRating(
        bookingId: _activeBooking!.id,
        rating: rating,
        comment: comment,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}
