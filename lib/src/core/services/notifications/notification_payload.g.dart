// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPayload _$NotificationPayloadFromJson(Map<String, dynamic> json) =>
    NotificationPayload(
      data: (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      title: json['title'] as String?,
      body: json['body'] as String?,
      imageUrl: json['imageUrl'] as String?,
      largeIconUrl: json['largeIconUrl'] as String?,
      bigPictureUrl: json['bigPictureUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      route: json['route'] as String?,
      deepLink: json['deepLink'] as String?,
      groupId: json['groupId'] as String?,
      notificationId: json['notificationId'] as String?,
      channelId: json['channelId'] as String?,
      category: json['category'] as String?,
      actions: NotificationPayload._parseActions(json['actions']),
    );

Map<String, dynamic> _$NotificationPayloadToJson(
  NotificationPayload instance,
) => <String, dynamic>{
  'title': instance.title,
  'body': instance.body,
  'imageUrl': instance.imageUrl,
  'largeIconUrl': instance.largeIconUrl,
  'bigPictureUrl': instance.bigPictureUrl,
  'thumbnailUrl': instance.thumbnailUrl,
  'route': instance.route,
  'deepLink': instance.deepLink,
  'data': instance.data,
  'groupId': instance.groupId,
  'notificationId': instance.notificationId,
  'channelId': instance.channelId,
  'category': instance.category,
  'actions': instance.actions,
};
