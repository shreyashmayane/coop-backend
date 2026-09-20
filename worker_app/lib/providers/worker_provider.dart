import 'package:flutter/material.dart';
import '../services/worker_service.dart';

class WorkerProvider extends ChangeNotifier {
  final WorkerService _service = WorkerService();

  bool _isAvailable = false;
  bool _loading = false;
  String? _error;

  bool get isAvailable => _isAvailable;
  bool get loading => _loading;
  String? get error => _error;

  // Ideally fetched from a profile endpoint, but for now we just toggle.
  void setInitialAvailability(bool status) {
    _isAvailable = status;
    notifyListeners();
  }

  Future<void> toggleAvailability(bool status) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _isAvailable = await _service.toggleStatus(status);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
