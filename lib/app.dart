import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/design-system-package/design_system_app.dart';
import 'package:hive_manager/design-system-package/src/themes/app_theme.dart';
import 'package:hive_manager/design-system-package/src/utils/app_theme_mode.dart';
import 'package:hive_manager/gen/fonts.gen.dart';
import 'package:hive_manager/src/config/app_auto_router_observer.dart';
import 'package:hive_manager/src/config/app_routes.dart';
import 'package:hive_manager/src/core/models/user_model.dart';
import 'package:hive_manager/src/core/provider/theme_notifier.dart';
// import 'package:hive_manager/src/core/provider/theme_notifier.dart';
// import 'package:hive_manager/src/core/provider/user_state.dart';
import 'package:hive_manager/src/core/utils/constants.dart';
// import 'package:hive_manager/src/features/user_management/domain/model/user_model.dart';
import 'package:intl/intl.dart' as intl;

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final autoRouteNotifier = ValueNotifier<UserModel?>(null);
  @override
  Widget build(BuildContext context) {
    // ref.listen<AsyncValue<UserModel?>>(userStateProvider, (prev, next) {
    //   // logger.info('userStateProvider: ${next.valueOrNull?.role}');
    //   final prevUser = prev?.valueOrNull;
    //   final nextUser = next.valueOrNull;

    //   if (nextUser == null) {
    //     autoRouteNotifier.value = null;
    //     return;
    //   }
    //   autoRouteNotifier.value = nextUser;
    // });

    //
    final appRouter = ref.watch(appRoutesProvider);
    final mode = ref.watch(themeProvider);
    // current locale
    final currentFontFamily = context.locale.languageCode == 'ar'
        ? FontFamily.expo
        : FontFamily.sora;

    intl.Intl.defaultLocale = context.locale.languageCode;
    final theme = AppTheme(
      context,
      mode.value!,
      context.locale.languageCode,
      currentFontFamily,
    );
    return DesignSystemApp(
      appTheme: theme,
      // The whole app now relies on adaptive_platform_ui for its shell:
      // AdaptiveApp renders Material on Android and native Cupertino / iOS 26
      // liquid-glass on iOS automatically, while keeping our auto_route config.
      builder: (context) => AdaptiveApp.router(
        routerConfig: appRouter.config(
          navigatorObservers: () => [AppAutoRouterObserver()],
          reevaluateListenable: autoRouteNotifier,
        ),
        builder: (context, widget) => widget ?? const SizedBox(),
        locale: context.locale,
        materialLightTheme: theme.themeData,
        materialDarkTheme: theme.themeData,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        title: Constants.get.appName,
        themeMode: mode.value == AppThemeMode.dark
            ? ThemeMode.dark
            : ThemeMode.light,
      ),
    );
  }
}
