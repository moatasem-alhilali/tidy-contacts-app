part of '../app_theme.dart';

/// Abstract class defining various insets for spacing and margin.
abstract class BaseInsets {
  /// Small inset value.
  ///
  /// In mobile case: `4`.
  double get sm;

  /// Medium inset value.
  ///
  /// In mobile case: `8`.
  double get md;

  /// Large inset value.
  ///
  /// In mobile case: `12`.
  double get lg;

  /// Extra large inset value.
  ///
  /// In mobile case: `16`.
  double get xl;

  /// Minor inset value.
  ///
  /// In mobile case: `24`.
  double get mn;
}