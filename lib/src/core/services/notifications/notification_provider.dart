// --- Firebase disabled (depends on AppNotificationService/FCM) — commented out ---
/*
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/src/config/app_routes.dart';
import 'package:hive_manager/src/core/extensions/extensions.dart';
import 'package:hive_manager/src/core/services/notifications/app_notification_service.dart';
import 'package:hive_manager/src/core/services/notifications/notification_payload.dart';

final notificationServiceProvider = Provider<AppNotificationService>((ref) {
  return AppNotificationService(
    onNavigate: (payload) {
      _handleNotificationNavigation(ref, payload);
    },
    onTokenRefresh: (token) {},
    onTokenInit: (token) {
      // ref.read(authFcmStateProvider.notifier).updateFCM(token);
    },
  );
});

void _handleNotificationNavigation(Ref ref, NotificationPayload payload) {
  if (payload.route != null) {
    final currentContext = Routers.navigatorKey.currentContext;
    if (currentContext != null) {
      final currentPath = currentContext.router.currentPath;
      if (currentPath.contains('/main/')) {
        currentContext.pushPathX(payload.route!.replaceFirst('/main/', ''));
      } else {
        currentContext.pushPathX(payload.route!);
      }
    }
  }
}
*/
