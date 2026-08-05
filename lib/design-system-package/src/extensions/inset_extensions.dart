part of 'extensions.dart';

extension BaseInsetsExtension on BaseInsets {

  double? fromName(String? insetName) {
    switch (insetName) {
      case 'md':
        return md;
      case 'sm':
        return sm;
      case 'lg':
        return lg;
      case 'xl':
        return xl;
      case 'mn':
        return mn;
      default:
        return null;
    }
  }
}
