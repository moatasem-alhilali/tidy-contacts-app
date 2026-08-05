class Constants {
  Constants._();

  static Constants get = Constants._();

  String appName = 'Contact Cleaner';

  /// keys for local storage
  String tokenKey = 'token';
  String refreshTokenKey = 'refreshToken';
  String languageKey = 'language';
  String fcmKey = 'fcm';
  String themeKey = 'theme';
  String deviceUuidKey = 'deviceUuid';
  String isBiometricEnabled = 'isBiometricEnabled';
}
