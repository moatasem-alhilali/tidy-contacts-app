part of 'extensions.dart';

extension AppThemeExtensions on AppTheme {
  bool get isEnglish {
    final currentLocale = intl.Intl.getCurrentLocale();
    return currentLocale == 'en';
  }
}
