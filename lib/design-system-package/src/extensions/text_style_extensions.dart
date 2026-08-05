part of 'extensions.dart';

extension BaseTextStyleExt on BaseTextStyle {
  TextStyle fromName(String styleName) {
    switch (styleName) {
      case 'displayLarge':
        return displayLarge;
      case 'displayMedium':
        return displayMedium;
      case 'displaySmall':
        return displaySmall;
      case 'headlineLarge':
        return headlineLarge;
      case 'headlineMedium':
        return headlineMedium;
      case 'headlineMediumBold':
        return headlineMediumBold;
      case 'headlineSmall':
        return headlineSmall;
      case 'headlineXSmall':
        return headlineXSmall;
      case 'titleLarge':
        return titleLarge;
      case 'titleMedium':
        return titleMedium;
      case 'titleSmall':
        return titleSmall;
      case 'titleSmallBold':
        return titleSmallBold;
      case 'labelLarge':
        return labelLarge;
      case 'labelMedium':
        return labelMedium;
      case 'labelSmall':
        return labelSmall;
      case 'labelSmallBold':
        return labelSmallBold;
      default:
        throw ArgumentError('Unknown text style name: $styleName');
    }
  }
}
