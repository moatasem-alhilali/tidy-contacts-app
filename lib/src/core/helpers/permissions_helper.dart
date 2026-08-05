import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  factory PermissionsHelper() => _instance;

  PermissionsHelper._();

  static final PermissionsHelper _instance = PermissionsHelper._();



  /// Method to check the notification permission status
  Future<bool> hasNotificationPermission() async {
    if (await Permission.notification.isGranted) {
      return true;
    }
    return false;
  }

  /// Method to request notification permission
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      await openAppSettings();
      if(await Permission.notification.request().isGranted) return true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      if(await Permission.notification.request().isGranted) return true;
    }

    return Permission.notification.isGranted;
  }
}
