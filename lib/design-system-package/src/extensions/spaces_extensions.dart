part of 'extensions.dart';

extension BaseSpacesExtension on BaseSpaces {
  double fromName(String? spaceName) {
    switch (spaceName) {
      case 'sm':
        return sm;
      case 'md':
        return md;
      case 'lg':
        return lg;
      case 'xl':
        return xl;
      case 'ex':
        return ex;
      case 'bottom':
        return bottom;
      default:
        return 0;
    }
  }
}
