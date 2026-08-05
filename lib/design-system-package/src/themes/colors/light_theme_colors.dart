part of '../app_theme.dart';

@immutable
class _LightThemeColors extends BaseColors {
  /// Brand accent for identity elements (logo marks, subtle highlights, badges).
  /// Use sparingly for brand feel; avoid large backgrounds.
  @override
  final Color brandColor = const Color(0xFF426DAD);
  @override
  final Color brand10Color = const Color(0xFFEDF1F9);

  @override
  final Color secondaryBrandColor = const Color(0xFFFF605A);

  /// Primary color for key actions (filled buttons, active toggles, key icons).
  /// Keep usage focused on primary CTAs and selected states.
  @override
  final Color primary = const Color(0xFF204594);

  /// Text/icon color that sits on top of [primary] surfaces.
  /// Must have strong contrast against [primary].
  @override
  final Color onPrimary = const Color(0xFFFFFFFF);

  /// Containers/chips using a lighter variant of primary (subtle emphasis).
  /// Use for secondary emphasis cards, chips, or info banners.
  @override
  final Color primaryContainer = const Color(0xFFFFFFFF);

  /// Text/icon color on top of [primaryContainer].
  /// Ensure contrast on light containers.
  @override
  final Color onPrimaryContainer = const Color(0xFF100E20);

  /// Secondary backgrounds for sections and input areas.
  /// Use for list rows, muted panels, and neutral surfaces.
  @override
  final Color secondary = const Color(0xFFF9F9F9);

  /// Subtle text on [secondary] (placeholders, helper text).
  /// Keep for low-importance labels
  @override
  final Color onSecondary = const Color(0xFF8E8E93);

  /// Neutral container for secondary blocks/cards.
  /// Use for dividers between content groups.
  @override
  final Color secondaryContainer = const Color(0xFFF9F9F9);

  /// Text/icon color on top of [secondaryContainer].
  @override
  final Color onSecondaryContainer = const Color(0xFFC7C7CC);

  /// Main scaffold background (app pages). Keep clean and bright.
  @override
  final Color surface = const Color(0xFFFFFFFF);

  /// Primary text on top of [surface] (body text, titles).
  @override
  final Color onSurface = const Color(0xFF1C1B1F);

  @override
  // final Color background = const Color(0xFFFFFFFF);
  final Color background = const Color(0xFFF7F7F7);

  @override
  final Color tertiary = const Color(0xFFF9F9F9);
  @override
  final Color onTertiary = const Color(0xFF100E20);
  @override
  final Color tertiaryContainer = const Color(0xFFF7F7F7);
  @override
  final Color onTertiaryContainer = const Color(0xFF100E20);

  @override
  final Color onBackground = const Color(0xFF1C1B1F);

  @override
  final Color surfaceVariant = const Color(0xFFF5F5F5);
  @override
  final Color onSurfaceVariant = const Color(0xFF1C1B1F);

  @override
  final Color errorContainer = const Color(0xFFFFDAD6);
  @override
  final Color onErrorContainer = const Color(0xFF410002);

  @override
  final Color outline = const Color(0xFF79747E);
  @override
  final Color shadow = const Color(0xFF000000);

  @override
  final Color inactive = const Color(0xFFD9DADC);
  @override
  final Color onInactive = const Color(0xFFA0A7AF);

  @override
  final Color error = const Color(0xFFFF0000);
  @override
  final Color onError = const Color(0xFFFFFFFF);

  /// The following colors below are fixed colors in all themes.
  @override
  final Color primaryFixed = const Color(0xFF28A745);

  @override
  final Color onPrimaryFixed = const Color(0xFF8D00BF);

  @override
  final Color secondaryFixed = const Color(0xFFF2C14F);

  @override
  final Color onSecondaryFixed = const Color(0xFFE7B913);

  @override
  final Color tertiaryFixed = const Color(0xFF3981F3);

  @override
  final Color onTertiaryFixed = const Color(0xFFFF9226);

  @override
  final Color black = const Color(0xFF000000);

  @override
  final Color white = const Color(0xFFFFFFFF);

  @override
  final Color grey = const Color(0xFF9F9FA6);

  @override
  final Color surfaceDim = const Color(0xFF8E8E93);
  @override
  final Color baseColor = const Color(0xFFF9F9F9);
  @override
  final Color highlightColor = const Color(0xFFFFFFFF);
  @override
  final Color secondaryButton = const Color(0xFFF2F2F2);

  @override
  final Color background$10 = const Color(0x1AFFFFFF);
  @override
  final Color background$30 = const Color(0x4CE4E4E4);
  @override
  final Color tent = const Color(0x800c0c0c);

  @override
  final Color primaryFixedLight = const Color(0xFFE3FBEA);

  @override
  final Color errorLight = const Color(0xFFFFF5F8);

  @override
  Color get darkGray => const Color(0xFF3c3c43);
}
