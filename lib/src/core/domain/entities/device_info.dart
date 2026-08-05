class DeviceInfo {
  DeviceInfo({
    this.deviceUuid,
    this.platform,
    this.model,
    this.appName,
    this.packageName,
    this.appVersion,
    this.buildNumber,
  });

  final String? platform;
  final String? model;
  final String? deviceUuid;
  final String? appName;
  final String? packageName;
  final String? appVersion;
  final String? buildNumber;
}
