import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_manager/app.dart';
import 'package:hive_manager/design-system-package/src/extensions/extensions.dart';


class ScreenUtilInitApp extends StatelessWidget {
  const ScreenUtilInitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      enableScaleWH: () => !context.isDesktop,
      child: const App(),
    );
  }
}
