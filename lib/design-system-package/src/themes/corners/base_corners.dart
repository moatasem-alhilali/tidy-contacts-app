part of '../app_theme.dart';

/// Abstract class defining various corner radii.
abstract class BaseCorners {
  /// Small radius.
  ///
  /// In mobile case: `Radius.circular(4)`.
  Radius get rs;

  /// Medium radius.
  ///
  /// In mobile case: `Radius.circular(8)`.
  Radius get rm;

  /// Large radius.
  ///
  /// In mobile case: `Radius.circular(50)`.
  Radius get rl;


  /// Big radius.
  ///
  /// In mobile case: `Radius.circular(50)`.
  Radius get rbi;

  /// Radius used for buttons.
  ///
  /// In mobile case: `Radius.circular(12)`.
  Radius get rb;

  /// Radius used for card elements.
  ///
  /// In mobile case: `Radius.circular(15)`.
  Radius get rc;

  /// Radius for a full circle (360 degrees).
  ///
  /// In mobile case: `Radius.circular(360)`.
  Radius get rc360;
}
