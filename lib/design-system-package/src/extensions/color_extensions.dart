part of 'extensions.dart';

extension BaseColorsExt on BaseColors {
  Color? fromName(String? colorName) {
    switch (colorName) {
      case 'primary':
        return primary;
      case 'secondary':
        return secondary;
      case 'tertiary':
        return tertiary;
      case 'error':
        return error;
      case 'errorLight':
        return errorLight;
      case 'surface':
        return surface;
      case 'surfaceDim':
        return surfaceDim;
      case 'primaryContainer':
        return primaryContainer;
      case 'secondaryContainer':
        return secondaryContainer;
      case 'tertiaryContainer':
        return tertiaryContainer;
      case 'onPrimary':
        return onPrimary;
      case 'onSecondary':
        return onSecondary;
      case 'onTertiary':
        return onTertiary;
      case 'onError':
        return onError;
      case 'onPrimaryContainer':
        return onPrimaryContainer;
      case 'onSecondaryContainer':
        return onSecondaryContainer;
      case 'onTertiaryContainer':
        return onTertiaryContainer;
      case 'onSurface':
        return onSurface;
      case 'inactive':
        return inactive;
      case 'onInactive':
        return onInactive;
      case 'primaryFixed':
        return primaryFixed;
      case 'primaryFixedLight':
        return primaryFixedLight;
      case 'onPrimaryFixed':
        return onPrimaryFixed;
      case 'secondaryFixed':
        return secondaryFixed;
      case 'onSecondaryFixed':
        return onSecondaryFixed;
      case 'tertiaryFixed':
        return tertiaryFixed;
      case 'onTertiaryFixed':
        return onTertiaryFixed;
      case 'white':
        return white;
      case 'black':
        return black;
      case 'grey':
        return grey;
      case 'baseColor':
        return baseColor;
      case 'highlightColor':
        return highlightColor;
      case 'secondaryButton':
        return secondaryButton;
      case 'background10':
        return background$10;
      case 'background30':
        return background$30;
      case 'tent':
        return tent;
      default:
        try{
          return Color(colorName.toInt);
        }catch(e){
          return null;
        }
    }
  }
}
