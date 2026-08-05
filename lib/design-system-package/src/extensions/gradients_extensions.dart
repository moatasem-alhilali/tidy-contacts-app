part of 'extensions.dart';

extension BaseGradientsExt on BaseGradients {
  Gradient? fromName(String? colorName) {
    switch (colorName) {
      case 'success':
        return success;
      case 'red':
        return red;
      case 'error':
        return error;
      case 'info':
        return info;
      case 'modal':
        return modal;
      case 'warning':
        return warning;
      case 'transparent':
        return transparent;
      case 'button':
        return button;
      case 'card':
        return card;
      default:
        return null;
    }
  }
}
