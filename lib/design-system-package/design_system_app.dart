import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/src/themes/app_theme.dart';

class DesignSystemApp extends StatelessWidget {
  const DesignSystemApp({
    required this.appTheme,
    required this.builder,
    super.key,
  });

  final AppTheme appTheme;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return _InheritedAppTheme(
      appTheme: appTheme,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: Builder(builder: builder),
      ),
    );
  }

  static AppTheme of(BuildContext context) {
    final inheritedAppTheme = context
        .dependOnInheritedWidgetOfExactType<_InheritedAppTheme>();
    assert(inheritedAppTheme != null, 'No AppTheme found in context');
    return inheritedAppTheme!.appTheme;
  }
}

class _InheritedAppTheme extends InheritedWidget {
  const _InheritedAppTheme({required this.appTheme, required super.child});

  final AppTheme appTheme;

  @override
  bool updateShouldNotify(_InheritedAppTheme oldWidget) =>
      appTheme != oldWidget.appTheme;
}
