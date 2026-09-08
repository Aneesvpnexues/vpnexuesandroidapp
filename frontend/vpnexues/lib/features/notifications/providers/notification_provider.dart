import 'package:flutter/foundation.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';
import 'package:vpnexues_pvt/core/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  Map<String, dynamic> _settings = {};

  List<Map<String, dynamic>> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get settings => _settings;

  /// Register FCM token with backend (call after login)
  Future<void> registerFcmToken() async {
    final notificationService = NotificationService();
    await notificationService.registerTokenWithBackend();
  }

  /// Remove FCM token from backend (call on logout)
  Future<void> removeFcmToken() async {
    final notificationService = NotificationService();
    await notificationService.removeTokenFromBackend();
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    _notifications = await _api.getNotifications();
    _unreadCount = await _api.getUnreadNotificationCount();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    await _api.markNotificationRead(id);
    _unreadCount = (_unreadCount - 1).clamp(0, 999);
    final index = _notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      _notifications[index]['read'] = true;
    }
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    await _api.markAllNotificationsRead();
    _unreadCount = 0;
    for (var notification in _notifications) {
      notification['read'] = true;
    }
    notifyListeners();
  }

  Future<void> deleteNotification(String id) async {
    await _api.deleteNotification(id);
    _notifications.removeWhere((n) => n['id'] == id);
    _unreadCount = (_unreadCount - 1).clamp(0, 999);
    notifyListeners();
  }

  Future<void> loadSettings() async {
    _settings = await _api.getNotificationSettings();
    notifyListeners();
  }

  Future<void> updateSettings(Map<String, dynamic> newSettings) async {
    final result = await _api.updateNotificationSettings(newSettings);
    if (result != null) {
      _settings = result;
      notifyListeners();
    }
  }
}
