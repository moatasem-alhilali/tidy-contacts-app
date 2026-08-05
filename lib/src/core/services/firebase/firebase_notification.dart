// --- Firebase disabled (not used currently) — entire file commented out ---
/*
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_manager/src/core/utils/logger.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  // Notification channel constants
  static const String _defaultChannelId = 'default_channel_v2';

  static const String _defaultChannelName = 'Default Notifications';

  //

  static const String _highImportanceChannelId = 'high_importance_channel';
  static const String _highImportanceChannelName =
      'High Importance Notifications';

  static const String _customChannelId = 'custom_channel';
  static const String _customChannelName = 'Custom Notifications';

  // Notification action IDs
  static const String _actionReply = 'reply';
  static const String _actionView = 'view';
  static const String _actionDismiss = 'dismiss';

  Future<void> initialize() async {
    try {
      // Firebase is already initialized in main.dart, so we don't need to initialize it here
      // Request permission first
      await _requestPermission();

      // Setup local notifications
      await setupFlutterNotifications();

      // Setup message handlers for foreground and app state changes
      await _setupMessageHandlers();

      // Get and log FCM token
      await getFCMToken();

      // Clear app badge on startup
      await _clearAppBadge();

      // logger.i('NotificationService initialized successfully');
    } catch (e) {
      logger.e('Error initializing notification service: $e');
    }
  }

  Future<NotificationSettings> _requestPermission() async {
    try {
      // Request FCM permissions
      final settings = await _messaging.requestPermission();

      // logger.i('FCM Permission status: ${settings.authorizationStatus}');

      // For iOS, request local notification permission
      if (Platform.isIOS) {
        final granted = await _localNotifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
        logger.i('iOS local notification permission granted: $granted');
      }

      // For Android 13+, request notification permission
      if (Platform.isAndroid) {
        final granted = await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
        // logger.i('Android notification permission granted: $granted');
      }

      return settings;
    } catch (e) {
      logger.e('Error requesting permission: $e');
      rethrow;
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    try {
      // Create multiple notification channels for Android
      await _createNotificationChannels();

      // Android initialization settings
      const initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS initialization settings
      const initializationSettingsDarwin = DarwinInitializationSettings();

      // Combined initialization settings
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        macOS: initializationSettingsDarwin,
      );

      // Initialize the plugin
      await _localNotifications.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );

      _isFlutterLocalNotificationsInitialized = true;
      logger.i('Flutter local notifications initialized successfully');
    } catch (e) {
      logger.e('Error setting up flutter notifications: $e');
      rethrow;
    }
  }

  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      final androidImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidImplementation != null) {
        // High importance channel
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            _highImportanceChannelId,
            _highImportanceChannelName,
            description:
                'This channel is used for high importance notifications.',
            importance: Importance.high,
            enableLights: true,
            sound: RawResourceAndroidNotificationSound('foam_zone'),
          ),
        );

        // Default channel
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            _defaultChannelId,
            _defaultChannelName,
            description: 'This channel is used for general notifications.',
            enableLights: true,
            sound: RawResourceAndroidNotificationSound('foam_zone'),
          ),
        );

        // Custom channel
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            _customChannelId,
            _customChannelName,
            description: 'This channel is used for custom notifications.',
            enableLights: true,
            sound: RawResourceAndroidNotificationSound('foam_zone'),
          ),
        );

        // logger.i('Android notification channels created');
      }
    }
  }

  // Callback for notification taps
  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    logger.i('Notification tapped: ${response.payload}');
    logger.i('Action ID: ${response.actionId}');

    // Handle notification tap here
    _handleNotificationTap(response.payload, response.actionId);
  }

  static void _handleNotificationTap(String? payload, String? actionId) {
    if (payload != null) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        logger.i('Handling notification tap with payload: $data');
        logger.i('Action ID: $actionId');

        // Handle different actions
        switch (actionId) {
          case _actionReply:
            logger.i('User chose to reply');
          case _actionView:
            logger.i('User chose to view');
          case _actionDismiss:
            logger.i('User chose to dismiss');
          default:
            logger.i('User tapped notification (no specific action)');
        }

        // Handle navigation based on type
        final type = data['type'] as String?;
        final route = data['route'] as String?;
        final id = data['id'] as String?;

        logger.i('Navigation data - Type: $type, Route: $route, ID: $id');

        // TODO: Implement navigation logic
        // NavigationService.instance.navigateTo(route, arguments: {'id': id});
      } catch (e) {
        logger.e('Error parsing notification payload: $e');
      }
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;

      if (notification != null) {
        // Determine the channel based on message type
        const importance = Importance.high;

        // Create notification actions
        final androidActions = <AndroidNotificationAction>[
          const AndroidNotificationAction(
            _actionView,
            'View',
            icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          ),
          const AndroidNotificationAction(_actionDismiss, 'Dismiss'),
        ];

        // Create notification details
        final androidNotificationDetails = AndroidNotificationDetails(
          _customChannelId,
          _customChannelName,
          channelDescription: 'This channel is used for custom notifications.',
          importance: importance,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          enableLights: true,
          sound: const RawResourceAndroidNotificationSound('foam_zone'),
          actions: androidActions,
          groupKey: message.data['type'] as String? ?? 'default',
          when: DateTime.now().millisecondsSinceEpoch,
          color: const Color.fromARGB(255, 33, 150, 243),
          colorized: true,
        );

        const iosNotificationDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1,
          subtitle: 'New notification',
          threadIdentifier: 'notification_thread',
          categoryIdentifier: 'general',
          interruptionLevel: InterruptionLevel.active,
        );

        final notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: iosNotificationDetails,
          macOS: iosNotificationDetails,
        );

        // Prepare payload
        final payload = <String, dynamic>{
          ...message.data,
          'title': notification.title,
          'body': notification.body,
          'timestamp': DateTime.now().toIso8601String(),
        };

        // Show the notification
        await _localNotifications.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: notificationDetails,
          payload: jsonEncode(payload),
        );

        logger.i('Notification shown: ${notification.title}');
      }
    } catch (e) {
      logger.e('Error showing notification: $e');
    }
  }

  // Local-only helper to show a notification without a RemoteMessage
  Future<void> showNotificationMock({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      const type = 'custom';
      const importance = Importance.high;

      final androidActions = <AndroidNotificationAction>[
        const AndroidNotificationAction(
          _actionView,
          'View',
          icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
        const AndroidNotificationAction(_actionDismiss, 'Dismiss'),
      ];

      final androidNotificationDetails = AndroidNotificationDetails(
        _customChannelId,
        _customChannelName,
        channelDescription: 'This channel is used for custom notifications.',
        importance: importance,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        enableLights: true,
        sound: const RawResourceAndroidNotificationSound('foam_zone'),
        actions: androidActions,
        groupKey: type,
        when: DateTime.now().millisecondsSinceEpoch,
        color: const Color.fromARGB(255, 33, 150, 243),
        colorized: true,
      );

      const iosNotificationDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        subtitle: 'New notification',
        threadIdentifier: 'notification_thread',
        categoryIdentifier: 'general',
        interruptionLevel: InterruptionLevel.active,
      );

      final notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
        macOS: iosNotificationDetails,
      );

      final payload = <String, dynamic>{
        ...?data,
        'title': title,
        'body': body,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _localNotifications.show(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: jsonEncode(payload),
      );
    } catch (e) {
      logger.e('Error showing local notification: $e');
    }
  }

  Future<void> _setupMessageHandlers() async {
    try {
      // Foreground message handler
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        logger.i('Got a message whilst in the foreground!');
        logger.i('Message data: ${message.data}');

        if (message.notification != null) {
          logger.i(
            'Message also contained a notification: ${message.notification}',
          );
          showNotification(message);
        }
      });

      // Background message handler (app is in background but not terminated)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        logger.i('A new onMessageOpenedApp event was published!');
        _handleBackgroundMessage(message);
      });

      // Terminated app handler
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        logger.i('App was opened from a terminated state by a notification');
        _handleBackgroundMessage(initialMessage);
      }

      // logger.i('Message handlers setup successfully');
    } catch (e) {
      logger.e('Error setting up message handlers: $e');
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    try {
      logger.i('Handling background message: ${message.data}');

      // Handle different notification types
      final type = message.data['type'] as String?;
      final route = message.data['route'] as String?;
      final id = message.data['id'] as String?;

      switch (type) {
        case 'chat':
          logger.i('Navigating to chat screen');
        case 'order':
          logger.i('Navigating to order screen');
        case 'general':
          logger.i('Navigating to general notification screen');
        default:
          logger.i('Unknown notification type: $type');
      }

      // TODO: Implement navigation logic
      // NavigationService.instance.navigateTo(route, arguments: {'id': id});
    } catch (e) {
      logger.e('Error handling background message: $e');
    }
  }

  Future<String?> getFCMToken() async {
    try {
      final token = await _messaging.getToken();
      // logger.i('FCM Token: $token');

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((String token) {
        // logger.i('FCM Token refreshed: $token');
        // TODO: Send token to your server here
        // ApiService.instance.updateFCMToken(token);
      });

      return token;
    } catch (e) {
      logger.e('Error getting FCM token: $e');
      return null;
    }
  }

  // Clear app badge
  Future<void> _clearAppBadge() async {
    try {
      if (Platform.isIOS) {
        await _localNotifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(badge: true);
      }
    } catch (e) {
      logger.e('Error clearing app badge: $e');
    }
  }

  // Get notification settings
  Future<bool> areNotificationsEnabled() async {
    try {
      if (Platform.isAndroid) {
        final enabled = await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled();
        return enabled ?? false;
      }

      if (Platform.isIOS) {
        final enabled = await _localNotifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions();
        return enabled ?? false;
      }

      return false;
    } catch (e) {
      logger.e('Error checking notification settings: $e');
      return false;
    }
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _localNotifications.cancel(id:id);
      logger.i('Notification $id cancelled');
    } catch (e) {
      logger.e('Error cancelling notification: $e');
    }
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
      logger.i('All notifications cancelled');
    } catch (e) {
      logger.e('Error cancelling all notifications: $e');
    }
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _localNotifications.pendingNotificationRequests();
    } catch (e) {
      logger.e('Error getting pending notifications: $e');
      return [];
    }
  }

  // Get active notifications (Android only)
  Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      if (Platform.isAndroid) {
        final notifications = await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.getActiveNotifications();
        return notifications ?? [];
      }
      return [];
    } catch (e) {
      logger.e('Error getting active notifications: $e');
      return [];
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      logger.i('Subscribed to topic: $topic');
    } catch (e) {
      logger.e('Error subscribing to topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      logger.i('Unsubscribed from topic: $topic');
    } catch (e) {
      logger.e('Error unsubscribing from topic: $e');
    }
  }

  // Get notification permission status
  Future<AuthorizationStatus> getNotificationPermissionStatus() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      return settings.authorizationStatus;
    } catch (e) {
      logger.e('Error getting notification permission status: $e');
      return AuthorizationStatus.notDetermined;
    }
  }

  // Check if notifications are properly configured
  Future<bool> isProperlyConfigured() async {
    try {
      final permissionStatus = await getNotificationPermissionStatus();
      final localNotificationsEnabled = await areNotificationsEnabled();

      return permissionStatus == AuthorizationStatus.authorized &&
          localNotificationsEnabled &&
          _isFlutterLocalNotificationsInitialized;
    } catch (e) {
      logger.e('Error checking configuration: $e');
      return false;
    }
  }
}
*/
