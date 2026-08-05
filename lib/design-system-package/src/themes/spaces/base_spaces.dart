part of '../app_theme.dart';

/// Abstract class defining various spaces for spacing and padding.
abstract class BaseSpaces {
  /// Small space value.
  ///
  /// In mobile case: `8`.
  double get sm;

  /// Medium space value.
  ///
  /// In mobile case: `16`.
  double get md;

  /// Large space value.
  ///
  /// In mobile case: `24`.
  double get lg;

  /// Extra large space value.
  ///
  /// In mobile case: `40`.
  double get xl;

  /// Expanded space value, typically used for larger padding or spacing.
  ///
  /// In mobile case: `double.infinity`.
  double get ex;

  /// Bottom space value.
  ///
  /// In mobile case: `20`.
  double get bottom;

}
