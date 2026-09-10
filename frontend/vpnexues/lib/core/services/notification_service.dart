import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  VoidCallback? onNotificationTap;
  Function(String title, String body)? onForegroundNotification;

  Future<void> initialize() async {
    debugPrint('NotificationService: Firebase disabled — using stub mode');
  }

  Future<void> registerTokenWithBackend() async {}

  Future<void> removeTokenFromBackend() async {}

  Future<void> subscribeToTopic(String topic) async {}

  Future<void> unsubscribeFromTopic(String topic) async {}
}
