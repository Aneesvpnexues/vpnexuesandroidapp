import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vpnexues_pvt/core/services/api_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background notification: ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final ApiService _api = ApiService();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  VoidCallback? onNotificationTap;
  Function(String title, String body)? onForegroundNotification;

  /// Initialize Firebase and FCM
  Future<void> initialize() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: false,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Get FCM token
      _fcmToken = await _messaging.getToken();
      debugPrint('FCM Token: $_fcmToken');

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        debugPrint('FCM Token refreshed: $newToken');
        _registerTokenWithBackend(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap (app opened from notification)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app opened from notification (cold start)
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }
    }
  }

  /// Register FCM token with your backend
  Future<void> registerTokenWithBackend() async {
    if (_fcmToken != null) {
      await _registerTokenWithBackend(_fcmToken!);
    }
  }

  Future<void> _registerTokenWithBackend(String token) async {
    try {
      await _api.registerFcmToken(token);
      debugPrint('FCM token registered with backend');
    } catch (e) {
      debugPrint('Failed to register FCM token: $e');
    }
  }

  /// Remove FCM token from backend (on logout)
  Future<void> removeTokenFromBackend() async {
    if (_fcmToken != null) {
      try {
        await _api.removeFcmToken(_fcmToken!);
        debugPrint('FCM token removed from backend');
      } catch (e) {
        debugPrint('Failed to remove FCM token: $e');
      }
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground notification: ${message.notification?.title}');

    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';

    if (title.isNotEmpty || body.isNotEmpty) {
      onForegroundNotification?.call(title, body);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.data}');

    onNotificationTap?.call();

    // Handle navigation based on notification data
    final data = message.data;
    if (data.containsKey('orderId')) {
      // Navigate to order details
      debugPrint('Navigate to order: ${data['orderId']}');
    } else if (data.containsKey('screen')) {
      // Navigate to specific screen
      debugPrint('Navigate to screen: ${data['screen']}');
    }
  }

  /// Subscribe to a topic (e.g., "orders_userId")
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }
}
