part of '../app_theme.dart';

/// Abstract class defining a color palette for theming.
abstract class BaseColors {
  /// The brand color used for major UI elements.
  Color get brandColor;

  Color get brand10Color;


    /// The brand color used for major UI elements.
  Color get secondaryBrandColor;


  /// The primary color used for major UI elements.
  Color get primary;

  /// The color used for text and icons on the primary color.
  Color get onPrimary;

  /// The secondary color used for supporting UI elements.
  Color get secondary;

  /// The color used for text and icons on the secondary color.
  Color get onSecondary;

  /// The tertiary color used for additional accents or elements.
  Color get tertiary;

  /// The color used for text and icons on the tertiary color.
  Color get onTertiary;

  /// The color used for error states or messages.
  Color get error;

  Color get errorLight;

  /// The color used for text and icons on the error color.
  Color get onError;

  /// The color for containers that hold primary content.
  Color get primaryContainer;

  /// The color used for text and icons on the primary container.
  Color get onPrimaryContainer;

  /// The color for containers that hold secondary content.
  Color get secondaryContainer;

  /// The color used for text and icons on the secondary container.
  Color get onSecondaryContainer;

  /// The color for containers that hold tertiary content.
  Color get tertiaryContainer;

  /// The color used for text and icons on the tertiary container.
  Color get onTertiaryContainer;

  /// The color used for the background surface of UI elements.
  Color get surface;

  /// The color used for text and icons on the surface color.
  Color get onSurface;

  /// The color used for the main background of the app.
  Color get background;

  /// The color used for text and icons on the background color.
  Color get onBackground;

  /// The color used for surface variants (e.g., cards, sheets).
  Color get surfaceVariant;

  /// The color used for text and icons on surface variant color.
  Color get onSurfaceVariant;

  /// The color used for error containers.
  Color get errorContainer;

  /// The color used for text and icons on error container color.
  Color get onErrorContainer;

  /// The color used for outlines and borders.
  Color get outline;

  /// The color used for shadows.
  Color get shadow;

  // TODO(Colors): The following colors below are fixed colors in all themes.
  /// The fixed color used for elements that do not change with the theme.
  /// Our custom color Success ( Green ).
  Color get primaryFixed;

  Color get primaryFixedLight;

  /// The color used for text and icons on the primary fixed color.
  /// Our custom color Crypto ( Purple )
  Color get onPrimaryFixed;

  /// The fixed color used for secondary elements that do not change with the theme.
  /// Our custom color Gold ( Golden )
  Color get secondaryFixed;

  /// The color used for text and icons on the secondary fixed color.
  /// Our custom color Warning ( Yellow)
  Color get onSecondaryFixed;

  /// The fixed color used for tertiary elements that do not change with the theme.
  /// Our custom color Info (Blu)
  Color get tertiaryFixed;

  /// The color used for text and icons on the tertiary fixed color.
  /// Our custom color Pending ( Orange )
  Color get onTertiaryFixed;

  Color get darkGray;

  Color get surfaceDim;

  /// The color used for a white background or text.
  Color get white;

  /// The color used for a black background or text.
  Color get black;

  /// The color used for a grey background or text.
  Color get grey;

  /// The color used for a disabled buttons .
  Color get inactive;

  /// The color used for on a disabled buttons.
  Color get onInactive;

  /// The color used for a shimmer.
  Color get baseColor;

  /// The color used for a shimmer.
  Color get highlightColor;

  /// The color used for a button.
  Color get secondaryButton;

  Color get background$10;

  Color get background$30;

  Color get tent;
}
