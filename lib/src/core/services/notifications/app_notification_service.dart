// --- Firebase disabled (not used currently) — entire file commented out ---
/*
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/src/core/services/notifications/local_notification_service.dart';
import 'package:hive_manager/src/core/services/notifications/notification_constants.dart';
import 'package:hive_manager/src/core/services/notifications/notification_image_helper.dart';
import 'package:hive_manager/src/core/services/notifications/notification_payload.dart';
import 'package:permission_handler/permission_handler.dart';

typedef NavigationHandler = void Function(NotificationPayload payload);
typedef OnTokenRefresh = void Function(String token);
typedef OnTokenInit = void Function(String token);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');

  var payload = NotificationPayload.fromJson(message.data);
  if (message.notification?.title != null) {
    payload = payload.copyWith(title: message.notification?.title);
  }
  if (message.notification?.body != null) {
    payload = payload.copyWith(body: message.notification?.body);
  }

  // // Initialize local notifications in background isolate
  // final localService = LocalNotificationService(
  //   navigatorKey: GlobalKey<NavigatorState>(),
  // );

  // await localService.initialize(
  //   onNotificationTap: (_) {},
  //   onNotificationAction: (_, __) {},
  // );

  // await localService.displayNotification(
  //   id: message.hashCode,
  //   payload: payload,
  //   preloadImages: false, // Don't preload in background
  // );
}

class AppNotificationService {
  AppNotificationService({
    required this.onNavigate,
    this.onTokenRefresh,
    this.onTokenInit,
  }) : _localNotificationService = LocalNotificationService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotificationService;

  final NavigationHandler onNavigate;
  final OnTokenRefresh? onTokenRefresh;
  final OnTokenInit? onTokenInit;

  final StreamController<NotificationPayload> _messageStreamController =
      StreamController<NotificationPayload>.broadcast();

  Stream<NotificationPayload> get messageStream =>
      _messageStreamController.stream;

  Future<void> initialize() async {
    try {
      await _setupLocalNotifications();
      await _configureFCM();
      await _handleTokenInit();
      await _processInitialMessage();
      _subscribeToDefaultTopics();
    } catch (_) {}
  }

  Future<void> _setupLocalNotifications() async {
    await _localNotificationService.initialize(
      onNotificationTap: _handleNotificationTap,
      onNotificationAction: _handleNotificationAction,
    );
  }

  Future<void> requestPermissions() async {
    await _firebaseMessaging.requestPermission();
    await Permission.notification.request();
  }

  Future<void> _configureFCM() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) async {
      var payload = NotificationPayload.fromJson(message.data);
      if (message.notification?.title != null) {
        payload = payload.copyWith(title: message.notification?.title);
      }
      if (message.notification?.body != null) {
        payload = payload.copyWith(body: message.notification?.body);
      }
    });

    // Background/terminated messages (when tapped)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      var payload = NotificationPayload.fromJson(message.data);
      if (message.notification?.title != null) {
        payload = payload.copyWith(title: message.notification?.title);
      }
      if (message.notification?.body != null) {
        payload = payload.copyWith(body: message.notification?.body);
      }
      _handleMessage(payload);
    });
    // Token refresh
    _firebaseMessaging.onTokenRefresh.listen((token) {
      debugPrint('FCM token refreshed: $token');
      onTokenRefresh?.call(token);
      _sendTokenToServer(token);
    });

    // iOS/MacOS foreground presentation
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> _handleTokenInit() async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      onTokenInit?.call(token);
    }
  }

  Future<void> _processInitialMessage() async {
    final message = await _firebaseMessaging.getInitialMessage();
    if (message != null) {
      var payload = NotificationPayload.fromJson(message.data);
      if (message.notification?.title != null) {
        payload = payload.copyWith(title: message.notification?.title);
      }
      if (message.notification?.body != null) {
        payload = payload.copyWith(body: message.notification?.body);
      }
    }
  }

  void _subscribeToDefaultTopics() {
    try {
      for (var topic in [
        NotificationConstants.testTopic,
        NotificationConstants.updatesTopic,
        NotificationConstants.allDevicesTopic,
      ]) {
        _firebaseMessaging.subscribeToTopic(topic);
      }
    } catch (_) {}
  }

  Future<String?> getDeviceToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      return null;
    }
  }

  Future<void> subscribeToTopic(String? topic) async {
    try {
      if (topic == null) return;
      await _firebaseMessaging.subscribeToTopic(topic);
    } catch (_) {}
  }

  Future<void> unsubscribeFromTopic(String? topic) async {
    try {
      if (topic == null) return;
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } catch (e) {}
  }

  void _handleMessage(NotificationPayload payload) {
    onNavigate(payload);
  }

  void _handleNotificationTap(NotificationPayload payload) {
    onNavigate.call(payload);
    _handleMessage(payload);
  }

  void _handleNotificationAction(String actionId, NotificationPayload payload) {
    switch (actionId) {
      case NotificationConstants.replyAction:
        _handleReplyAction(payload);
      case NotificationConstants.viewAction:
        _handleViewAction(payload);
    }
  }

  void _handleReplyAction(NotificationPayload payload) {
    // Show reply UI or process reply
  }

  void _handleViewAction(NotificationPayload payload) {
    _handleMessage(payload);
  }

  Future<void> _sendTokenToServer(String token) async {
    // Implement your server communication here
  }

  Future<void> displayCustomNotification({
    required int id,
    required NotificationPayload payload,
    bool preloadImages = true,
  }) async {
    await _localNotificationService.displayNotification(
      id: id,
      payload: payload,
      preloadImages: preloadImages,
    );
  }

  void dispose() {
    _messageStreamController.close();
    NotificationImageHelper.clearCache();
  }
}
*/
