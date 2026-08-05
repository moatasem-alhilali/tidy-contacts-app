import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';
import 'package:hive_manager/src/core/utils/utils.dart';
import 'package:hive_manager/src/core/widgets/new/base_app_bar_widget.dart';

class AppScaffoldWidget extends StatelessWidget {
  const AppScaffoldWidget({
    required this.child,
    this.footer,
    this.bottomNavigationBar,
    this.scaffoldKey,
    this.statusBarColor,
    this.scaffoldBackgroundColor,
    this.statusBarIconLight,
    this.resizeToAvoidBottomInset,
    this.useTopSafeArea,
    this.useBottomSafeArea,
    this.padding,
    this.backgroundWidget,
    this.drawer,
    this.appBar,
    this.floatingActionButton,

    super.key,
    this.hasAppBar,
    this.appBarTitle,
    this.onBack,
  });

  final Widget child;
  final Widget? footer;
  final Widget? bottomNavigationBar;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Color? statusBarColor;
  final Color? scaffoldBackgroundColor;
  final bool? statusBarIconLight;
  final bool? resizeToAvoidBottomInset;
  final bool? useTopSafeArea;
  final bool? useBottomSafeArea;
  final Widget? backgroundWidget;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;
  final PreferredSizeWidget? appBar;
  final bool? hasAppBar;
  final String? appBarTitle;
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? Colors.transparent,
        statusBarIconBrightness:
            (statusBarIconLight ?? context.designSystem.lightBrightness)
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness:
            (statusBarIconLight ?? context.designSystem.lightBrightness)
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: context.colors.background,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            (statusBarIconLight ?? context.designSystem.lightBrightness)
            ? Brightness.dark
            : Brightness.light,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor:
              scaffoldBackgroundColor ?? context.colors.background,

          dividerTheme: DividerThemeData(
            color: footer == null ? null : Colors.transparent,
          ),
        ),
        child: Scaffold(
          key: scaffoldKey,
          appBar: appBar ?? BaseAppBarWidget(title: appBarTitle ?? ''),
          drawer: drawer,
          extendBody: true,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          backgroundColor: scaffoldBackgroundColor ?? context.colors.background,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: floatingActionButton,
          body: Stack(
            clipBehavior: Clip.none,

            fit: StackFit.expand,
            children: [
              backgroundWidget ??
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: const [0.0, 0.6, 1.0],
                        colors: isDarkMode
                            ? [
                                const Color(0xFF0e0c15),
                                const Color(0xFF101427),
                                const Color(0xFF141F44),
                              ]
                            : [
                                const Color(0xFFF5F7FA),
                                const Color(0xFFE4ECF7),
                                const Color(0xFFD4E0F4),
                              ],
                      ),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                  ),
              GestureDetector(
                onTap: () => Utils.disposeKeyboard(context),
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: isDarkMode
                        ? Brightness.light
                        : Brightness.dark,
                    systemNavigationBarColor: context.colors.background,
                    systemNavigationBarIconBrightness: isDarkMode
                        ? Brightness.light
                        : Brightness.dark,
                  ),
                  child: SafeArea(
                    top: isDarkMode,
                    bottom: useBottomSafeArea ?? true,
                    child: Padding(
                      padding:
                          padding ??
                          EdgeInsets.only(
                            bottom:
                                context.bottomSpace -
                                context.statusBottomHeight,
                          ),
                      child: ColoredBox(
                        color: context.colors.background,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: ColoredBox(
            color: context.colors.background,
            child: bottomNavigationBar,
          ),
          // persistentFooterButtons: footer != null
          //     ? [
          //         Container(
          //           transform: Matrix4.translationValues(
          //             0,
          //             context.bottomSpace > context.spaces.bottom
          //                 ? 8
          //                 : -(context.spaces.bottom - 8),
          //             0,
          //           ),
          //           padding: EdgeInsets.symmetric(
          //             horizontal: context.insets.mn - 8,
          //           ),
          //           child: footer,
          //         ),
          //       ]
          //     : null,
        ),
      ),
    );
  }
}
