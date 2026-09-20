import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthState { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  static const String _guestKey = 'is_guest';

  AuthState _authState = AuthState.unknown;
  UserModel? _user;
  String? _error;
  bool _loading = false;
  bool _isGuest = false;

  AuthState get authState => _authState;
  UserModel? get user => _user;
  String? get error => _error;
  bool get loading => _loading;
  bool get isAuthenticated => _authState == AuthState.authenticated;
  bool get isGuest => _isGuest;

  /// Called once on app startup to check stored token.
  Future<void> checkAuthStatus() async {
    _loading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final guestMode = prefs.getBool(_guestKey) ?? false;

    if (guestMode) {
      _isGuest = true;
      _user = const UserModel(id: 'guest', name: 'Guest', phone: '');
      _authState = AuthState.authenticated;
    } else {
      final loggedIn = await _authService.isLoggedIn();
      if (loggedIn) {
        _user = await _authService.getCachedUser();
        _authState = AuthState.authenticated;
      } else {
        _authState = AuthState.unauthenticated;
      }
    }

    _loading = false;
    notifyListeners();
  }

  /// Log in as guest — no API call, local-only session.
  Future<void> loginAsGuest() async {
    _loading = true;
    _error = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestKey, true);

    _isGuest = true;
    _user = const UserModel(id: 'guest', name: 'Guest', phone: '');
    _authState = AuthState.authenticated;
    _loading = false;
    notifyListeners();
  }

  Future<bool> login(String phone, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authService.login(phone: phone, password: password);
      _isGuest = false;
      _authState = AuthState.authenticated;
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('ApiException(', '').replaceFirst('): ', ': ');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String phone, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.register(name: name, phone: phone, password: password);
      // Auto-login after register
      return await login(phone, password);
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    // Clear guest flag too
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_guestKey);
    _user = null;
    _isGuest = false;
    _authState = AuthState.unauthenticated;
    notifyListeners();
  }

  void updateLocale(String locale) {
    if (_user != null) {
      _user = _user!.copyWith(locale: locale);
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

