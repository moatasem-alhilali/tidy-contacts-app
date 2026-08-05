part of '../bottom_navigation_bar.dart';

class NavigationBarEntity {
  const NavigationBarEntity({
    required this.icon,
    required this.selectedIcon,
    this.route,
    this.text,
    this.label,
  });

  final String icon;
  final String selectedIcon;
  final String? text;
  final String? label;
  final String? route;

  @override
  bool operator ==(covariant NavigationBarEntity other) {
    if (identical(this, other)) return true;

    return other.icon == icon &&
        other.selectedIcon == selectedIcon &&
        other.text == text &&
        other.label == label &&
        other.route == route;
  }

  @override
  int get hashCode {
    return icon.hashCode ^
        selectedIcon.hashCode ^
        text.hashCode ^
        label.hashCode ^
        route.hashCode;
  }
}
