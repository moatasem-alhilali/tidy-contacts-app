import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_manager/src/core/services/notifications/notification_constants.dart';
import 'package:hive_manager/src/core/services/notifications/notification_image_helper.dart';
import 'package:hive_manager/src/core/services/notifications/notification_payload.dart';

typedef OnNotificationTap = void Function(NotificationPayload payload);
typedef OnNotificationAction =
    void Function(String actionId, NotificationPayload payload);

class LocalNotificationService {
  LocalNotificationService();
  late final FlutterLocalNotificationsPlugin _notificationsPlugin;
  OnNotificationTap? _onNotificationTap;
  OnNotificationAction? _onNotificationAction;

  Future<void> initialize({
    required OnNotificationTap onNotificationTap,
    OnNotificationAction? onNotificationAction,
    String defaultAndroidIcon = '@mipmap/ic_launcher',
    List<AndroidNotificationChannel>? additionalChannels,
  }) async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    _onNotificationTap = onNotificationTap;
    _onNotificationAction = onNotificationAction;

    // Android initialization
    final androidSettings = AndroidInitializationSettings(defaultAndroidIcon);

    // iOS/MacOS initialization
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          _handleBackgroundNotificationResponse,
    );

    if (defaultTargetPlatform == TargetPlatform.android) {
      await _createAndroidChannels(additionalChannels);
    }
  }

  Future<void> _createAndroidChannels(
    List<AndroidNotificationChannel>? additionalChannels,
  ) async {
    final channels = <AndroidNotificationChannel>[
      const AndroidNotificationChannel(
        NotificationConstants.androidDefaultChannelId,
        NotificationConstants.androidDefaultChannelName,
        description: NotificationConstants.androidDefaultChannelDesc,
      ),
      const AndroidNotificationChannel(
        NotificationConstants.androidHighPriorityChannelId,
        NotificationConstants.androidHighPriorityChannelName,
        description: NotificationConstants.androidHighPriorityChannelDesc,
        importance: Importance.high,
      ),
      ...?additionalChannels,
    ];

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    for (final channel in channels) {
      await androidPlugin?.createNotificationChannel(channel);
    }
  }

  Future<void> displayNotification({
    required int id,
    required NotificationPayload payload,
    String? explicitChannelId,
    bool preloadImages = true,
  }) async {
    if (preloadImages) {
      await NotificationImageHelper.preloadImages(payload);
    }

    final channelId =
        explicitChannelId ??
        payload.channelId ??
        NotificationConstants.androidDefaultChannelId;

    // Handle images
    final largeIconPath = payload.largeIconUrl != null
        ? await NotificationImageHelper.downloadAndCacheImage(
            payload.largeIconUrl!,
            fileName: 'large_icon_$id',
          )
        : null;

    final bigPicturePath = payload.bigPictureUrl != null
        ? await NotificationImageHelper.downloadAndCacheImage(
            payload.bigPictureUrl!,
            fileName: 'big_picture_$id',
          )
        : null;

    // Android details
    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance:
          channelId == NotificationConstants.androidHighPriorityChannelId
          ? Importance.high
          : Importance.defaultImportance,
      priority: channelId == NotificationConstants.androidHighPriorityChannelId
          ? Priority.high
          : Priority.defaultPriority,
      groupKey: payload.groupId,
      setAsGroupSummary: payload.groupId != null,
      largeIcon: largeIconPath != null
          ? FilePathAndroidBitmap(largeIconPath)
          : null,
      styleInformation: bigPicturePath != null
          ? BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicturePath),
              largeIcon: largeIconPath != null
                  ? FilePathAndroidBitmap(largeIconPath)
                  : null,
              contentTitle: payload.title,
              htmlFormatContentTitle: true,
              summaryText: payload.body,
              htmlFormatSummaryText: true,
            )
          : BigTextStyleInformation(
              payload.body ?? '',
              htmlFormatBigText: true,
              contentTitle: payload.title,
              htmlFormatContentTitle: true,
            ),
      actions: _getAndroidActions(payload.actions),
    );

    // iOS/MacOS details
    final darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
      threadIdentifier: payload.groupId,
      attachments: payload.thumbnailUrl != null
          ? [DarwinNotificationAttachment(payload.thumbnailUrl!)]
          : null,
      categoryIdentifier: payload.category,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _notificationsPlugin.show(
      id: id,
      title: payload.title,
      body: payload.body,
      notificationDetails: details,
      payload: jsonEncode(payload.toJson()),
    );
  }

  List<AndroidNotificationAction> _getAndroidActions(List<String>? actions) {
    if (actions == null || actions.isEmpty) return [];

    return actions.map((action) {
      switch (action) {
        case NotificationConstants.replyAction:
          return const AndroidNotificationAction(
            NotificationConstants.replyAction,
            'Reply',
            showsUserInterface: true,
            inputs: [AndroidNotificationActionInput(label: 'Message')],
          );
        case NotificationConstants.viewAction:
          return const AndroidNotificationAction(
            NotificationConstants.viewAction,
            'View',
            showsUserInterface: true,
          );
        default:
          return AndroidNotificationAction(action, action.capitalize());
      }
    }).toList();
  }

  void _handleNotificationResponse(NotificationResponse response) {
    try {
      if (response.payload == null) return;

      final payload = NotificationPayload.fromJson(
        jsonDecode(response.payload!) as Map<String, dynamic>,
      );

      if (response.actionId?.isNotEmpty ?? false) {
        _onNotificationAction?.call(response.actionId!, payload);
      } else {
        _onNotificationTap?.call(payload);
      }
    } catch (e) {
      debugPrint('Error handling notification response: $e');
    }
  }

  @pragma('vm:entry-point')
  static void _handleBackgroundNotificationResponse(
    NotificationResponse response,
  ) {
    // This runs in a background isolate
    // Save the payload to shared preferences or similar
    // The main isolate will handle it when the app starts
    debugPrint('Background notification tapped: ${response.payload}');
  }

  String _getChannelName(String channelId) {
    switch (channelId) {
      case NotificationConstants.androidHighPriorityChannelId:
        return NotificationConstants.androidHighPriorityChannelName;
      default:
        return NotificationConstants.androidDefaultChannelName;
    }
  }

  String _getChannelDescription(String channelId) {
    switch (channelId) {
      case NotificationConstants.androidHighPriorityChannelId:
        return NotificationConstants.androidHighPriorityChannelDesc;
      default:
        return NotificationConstants.androidDefaultChannelDesc;
    }
  }

  Future<void> cancelNotification(int id) async =>
      _notificationsPlugin.cancel(id: id);
  Future<void> cancelAllNotifications() async =>
      _notificationsPlugin.cancelAll();
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
