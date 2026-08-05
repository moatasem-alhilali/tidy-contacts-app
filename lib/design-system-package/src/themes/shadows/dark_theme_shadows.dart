part of '../app_theme.dart';

@immutable
class _DarkThemeShadows extends BaseShadows {
  @override
  // TODO: implement large
  final BoxShadow large = BoxShadow(
    blurRadius: 10,
    color: Colors.black.withValues(alpha: 0.1),
  );

  @override
  // TODO: implement medium
  final BoxShadow medium = BoxShadow(
    blurRadius: 5,
    color: Colors.black.withValues(alpha: 0.1),
  );

  @override
  // TODO: implement small
  final BoxShadow small = BoxShadow(
    blurRadius: 2,
    color: Colors.black.withValues(alpha: 0.1),
  );
}
