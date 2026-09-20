import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider extends ChangeNotifier {
  final BookingService _service = BookingService();

  List<BookingModel> _bookings = [];
  bool _loading = false;
  String? _error;

  List<BookingModel> get bookings => _bookings;
  List<BookingModel> get pendingBookings => _bookings.where((b) => b.status == 'pending').toList();
  List<BookingModel> get activeBookings => _bookings.where((b) => b.status == 'accepted' || b.status == 'in_progress').toList();
  
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchBookings() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _bookings = await _service.getWorkerBookings();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStatus(String id, String status) async {
    try {
      await _service.updateBookingStatus(id, status);
      await fetchBookings();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
