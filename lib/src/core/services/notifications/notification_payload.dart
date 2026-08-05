import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_payload.freezed.dart';
part 'notification_payload.g.dart';

@JsonSerializable(explicitToJson: true)
@freezed
class NotificationPayload with _$NotificationPayload {
  NotificationPayload({
    this.data,
    this.title,
    this.body,
    this.imageUrl,
    this.largeIconUrl,
    this.bigPictureUrl,
    this.thumbnailUrl,
    this.route,
    this.deepLink,
    this.groupId,
    this.notificationId,
    this.channelId,
    this.category,
    this.actions,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);

  @override
  final String? title;
  @override
  final String? body;
  @override
  final String? imageUrl;
  @override
  final String? largeIconUrl;
  @override
  final String? bigPictureUrl;
  @override
  final String? thumbnailUrl;
  @override
  final String? route;
  @override
  final String? deepLink;
  @override
  final Map<String, String>? data;
  @override
  final String? groupId;
  @override
  final String? notificationId;
  @override
  final String? channelId;
  @override
  final String? category;
  @override
  @JsonKey(fromJson: _parseActions)
  final List<String>? actions;

  Map<String, dynamic> toJson() => _$NotificationPayloadToJson(this);

  static List<String>? _parseActions(dynamic actionData) {
    if (actionData == null) return null;
    if (actionData is String) {
      return actionData.split(',');
    } else if (actionData is List) {
      return actionData.cast<String>();
    }
    return null;
  }
}
