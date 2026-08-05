class NotificationConstants {
  // Android Notification Channels
  static const String androidDefaultChannelId = 'default_channel';
  static const String androidDefaultChannelName = 'Default Notifications';
  static const String androidDefaultChannelDesc = 'General app notifications';
  
  static const String androidHighPriorityChannelId = 'high_priority_channel';
  static const String androidHighPriorityChannelName = 'Important Notifications';
  static const String androidHighPriorityChannelDesc = 'Time-sensitive notifications';

  // iOS/MacOS Specific
  static const String iosDefaultSound = 'default';

  // Payload Keys
  static const String routeKey = 'route';
  static const String deepLinkKey = 'deep_link';
  static const String imageKey = 'image_url';
  static const String largeIconKey = 'large_icon_url';
  static const String bigPictureKey = 'big_picture_url';
  static const String thumbnailKey = 'thumbnail_url';
  static const String groupKey = 'group_id';
  static const String categoryKey = 'category';
  static const String actionKey = 'action';
  static const String notificationIdKey = 'notification_id';

  // Topics
  static const String allDevicesTopic = 'all_devices';
  static const String testTopic = 'dev_test';
  static const String updatesTopic = 'app_updates';

  // Categories
  static const String messageCategory = 'MESSAGE';
  static const String updateCategory = 'UPDATE';

  // Actions
  static const String replyAction = 'REPLY_ACTION';
  static const String viewAction = 'VIEW_ACTION';
}