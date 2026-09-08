import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';
import 'package:vpnexues_pvt/core/services/notification_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  Map<String, dynamic>? _user;
  bool _isLoading = false;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoggedIn => _token != null;
  bool get isLoading => _isLoading;

  String? get userId => _user?['id'];
  String? get userName => _user?['name'] ?? _user?['email'];
  String? get userEmail => _user?['email'];
  String? get userPhone => _user?['phone'];

  Future<bool> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final storedToken = await _storage.read(key: 'auth_token');
      if (storedToken == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _token = storedToken;
      _api.setToken(storedToken);
      final userJson = await _storage.read(key: 'user_data');
      if (userJson != null) {
        _user = Map<String, dynamic>.from(
          Map.from(_decodeJson(userJson)),
        );
      }

      // Validate token with server
      try {
        final userData = await _api.getCurrentUser(_token!);
        if (userData != null) {
          _user = userData;
          await _storage.write(key: 'user_data', value: _encodeJson(userData));
        }
      } catch (_) {
        // Token invalid - logout
        await logout();
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoading = false;
      notifyListeners();

      // Register FCM token after successful auto-login
      try {
        await NotificationService().registerTokenWithBackend();
      } catch (_) {}

      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> login(String token, Map<String, dynamic> user) async {
    _token = token;
    _user = user;
    _api.setToken(token);

    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'user_data', value: _encodeJson(user));

    notifyListeners();

    // Register FCM token after login
    try {
      await NotificationService().registerTokenWithBackend();
    } catch (_) {}
  }

  Future<void> logout() async {
    // Remove FCM token before logout
    try {
      await NotificationService().removeTokenFromBackend();
    } catch (_) {}

    _token = null;
    _user = null;
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_data');
    notifyListeners();
  }

  Future<bool> updateProfile({String? name, String? phone, String? language}) async {
    try {
      final result = await _api.updateProfile(name: name, phone: phone, language: language);
      if (result != null) {
        _user = result;
        await _storage.write(key: 'user_data', value: _encodeJson(result));
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  String _encodeJson(Map<String, dynamic> json) {
    return jsonEncode(json);
  }

  Map<String, dynamic> _decodeJson(String jsonStr) {
    final decoded = jsonDecode(jsonStr);
    if (decoded is Map<String, dynamic>) return decoded;
    return Map<String, dynamic>.from(decoded as Map);
  }
}
