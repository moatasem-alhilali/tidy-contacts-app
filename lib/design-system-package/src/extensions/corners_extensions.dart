part of 'extensions.dart';

extension CornersExtension on BaseCorners {
  Radius fromName(String? spaceName) {
    switch (spaceName) {
      case 'rs':
        return rs;
      case 'rm':
        return rm;
      case 'rl':
        return rl;
      case 'rbi':
        return rbi;
      case 'rb':
        return rb;
      case 'rc':
        return rc;
      case 'rc360':
        return rc360;
      default:
        return Radius.zero;
    }
  }
}
