import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/service_category_model.dart';
import '../models/worker_model.dart';
import '../services/worker_service.dart';

class WorkerProvider extends ChangeNotifier {
  final WorkerService _service = WorkerService();

  List<ServiceCategoryModel> _categories = [];
  List<WorkerModel> _workers = [];
  WorkerModel? _selectedWorker;
  ServiceCategoryModel? _selectedCategory;
  Position? _currentPosition;
  bool _loading = false;
  String? _error;

  List<ServiceCategoryModel> get categories => _categories;
  List<WorkerModel> get workers => _workers;
  WorkerModel? get selectedWorker => _selectedWorker;
  ServiceCategoryModel? get selectedCategory => _selectedCategory;
  bool get loading => _loading;
  String? get error => _error;
  Position? get currentPosition => _currentPosition;

  Future<void> loadCategories() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _categories = await _service.getCategories();
    } catch (e) {
      _categories = ServiceCategoryModel.mockList();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadNearbyWorkers(ServiceCategoryModel category) async {
    _selectedCategory = category;
    _loading = true;
    _error = null;
    _workers = [];
    notifyListeners();

    // Try to get location
    double lat = 12.9716, lng = 77.5946; // default: Bengaluru
    try {
      final perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );
      lat = pos.latitude;
      lng = pos.longitude;
      _currentPosition = pos;
    } catch (_) {
      // Use default coords if location unavailable
    }

    try {
      _workers = await _service.getNearbyWorkers(
        lat: lat,
        lng: lng,
        serviceType: category.name,
      );
    } catch (e) {
      _workers = WorkerModel.mockList(category.name);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> selectWorker(String id) async {
    _selectedWorker = _workers.cast<WorkerModel?>().firstWhere(
          (w) => w?.id == id,
          orElse: () => null,
        );
    if (_selectedWorker == null) {
      final full = await _service.getWorkerById(
          id, _selectedCategory?.name ?? '');
      _selectedWorker = full;
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedWorker = null;
    _selectedCategory = null;
    notifyListeners();
  }
}
