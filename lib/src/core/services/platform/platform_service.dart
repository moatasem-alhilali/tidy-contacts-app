import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:hive_manager/src/core/domain/entities/device_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PlatformService {
  factory PlatformService() => _instance;

  PlatformService._();

  static final PlatformService _instance = PlatformService._();

  static Future<DeviceInfo> get getDeviceInfo async {
    late String platform;
    late String model;
    late String? deviceUuid;
    final deviceInfo = DeviceInfoPlugin();

    // Get app version information
    final packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      platform = 'android';
      model = androidInfo.model; // Get the Android model
      deviceUuid = androidInfo.id; // Get the Android model
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      platform = 'ios';
      model = iosInfo.utsname.machine; // Get the iOS model
      deviceUuid = iosInfo.identifierForVendor; // Get the Android model
    } else if (Platform.isMacOS) {
      final iosInfo = await deviceInfo.macOsInfo;
      platform = 'mac';
      model = iosInfo.model; // Get the iOS model
      deviceUuid = iosInfo.systemGUID;
    } else if (Platform.isWindows) {
      final windowsInfo = await deviceInfo.windowsInfo;
      platform = 'windows';
      model = windowsInfo.productName; // Get the Windows model
      deviceUuid = windowsInfo.deviceId;
    } else if (Platform.isLinux) {
      final windowsInfo = await deviceInfo.linuxInfo;
      platform = 'windows';
      model = windowsInfo.prettyName; // Get the Windows model
      deviceUuid = windowsInfo.buildId;
    } else {
      platform = 'unknown';
      model = 'unknown';
      deviceUuid = 'unknown';
    }
    final deviceInfoEntity = DeviceInfo(
      platform: platform,
      model: model,
      deviceUuid: deviceUuid,
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
    );
    return deviceInfoEntity;
  }
}
