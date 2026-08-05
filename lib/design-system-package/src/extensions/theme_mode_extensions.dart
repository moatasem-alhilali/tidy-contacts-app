part of 'extensions.dart';

extension ThemeModeExtensions on AppThemeMode {
  T mode<T>(T light, T dark) {
    if (this == AppThemeMode.dark) {
      return dark;
    }
    return light;
  }
}
