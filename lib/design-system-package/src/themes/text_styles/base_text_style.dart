part of '../app_theme.dart';

mixin _TextStyle implements BaseTextStyle {
  TextStyle createTextStyle({
    required double fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      letterSpacing: 0,
    );
  }
}

/// Abstract class defining various text styles.
abstract class BaseTextStyle {
  /// Font size for large X display text.
  ///
  /// Typically used for main titles or prominent headings.
  /// Example: `fontSize: 50`
  TextStyle get displayXLarge;

  /// Font size for large display text.
  ///
  /// Typically used for main titles or prominent headings.
  /// Example: `fontSize: 34`
  TextStyle get displayLarge;

  /// Font size for medium display text.
  ///
  /// Often used for secondary titles or large subtitles.
  /// Example: `fontSize: 34`
  TextStyle get displayMedium;

  /// Font size for small display text.
  ///
  /// Suitable for smaller headings or emphasis on text.
  /// Example: `fontSize: 25`
  TextStyle get displaySmall;

  /// Font size for large headlines.
  ///
  /// Commonly used for major section headings.
  /// Example: `fontSize: 22`
  TextStyle get headlineLarge;

  /// Font size for medium headlines.
  ///
  /// Typically used for sub-headings within sections.
  /// Example: `fontSize: 20`
  TextStyle get headlineMedium;

  /// Font size for medium headlines.
  ///
  /// Typically used for sub-headings within sections.
  /// Example: `fontSize: 20`
  TextStyle get headlineMediumBold;

  /// Font size for small headlines.
  ///
  /// Used for less prominent headings.
  /// Example: `fontSize: 16`
  TextStyle get headlineSmall;

  /// Font size for large body text.
  ///
  /// Suitable for main content text.
  /// Example: `fontSize: 14`
  TextStyle get headlineXSmall;

  /// Font size for large titles.
  ///
  /// Often used for prominent titles in lists or cards.
  /// Example: `fontSize: 17`
  TextStyle get titleLarge;

  /// Font size for medium titles.
  ///
  /// Suitable for moderate emphasis titles.
  /// Example: `fontSize: 15`
  TextStyle get titleMedium;

  /// Font size for small titles.
  ///
  /// Typically used for smaller titles or labels.
  /// Example: `fontSize: 13`
  TextStyle get titleSmall;

  /// Font size for small titles.
  ///
  /// Typically used for smaller titles or labels.
  /// Example: `fontSize: 13`
  TextStyle get titleSmallBold;

  /// Font size for large labels.
  ///
  /// Commonly used for important labels in forms or buttons.
  /// Example: `fontSize: 12`
  TextStyle get labelLarge;

  /// Font size for medium labels.
  ///
  /// Often used for standard labels in forms or interfaces.
  /// Example: `fontSize: 10`
  TextStyle get labelMedium;

  /// Font size for small labels.
  ///
  /// Typically used for less significant labels.
  /// Example: `fontSize: 8`
  TextStyle get labelSmall;

  /// Font size for small labels.
  ///
  /// Typically used for less significant labels.
  /// Example: `fontSize: 8`
  TextStyle get labelSmallBold;

  /// Font size for large body text.
  ///
  /// Suitable for main content text.
  /// Example: `fontSize: 16`
  TextStyle get bodyLarge;

  /// Font size for medium body text.
  ///
  /// Commonly used for standard content text.
  /// Example: `fontSize: 14`
  TextStyle get bodyMedium;

  /// Font size for small body text.
  ///
  /// Typically used for secondary content or captions.
  /// Example: `fontSize: 12`
  TextStyle get bodySmall;
}
