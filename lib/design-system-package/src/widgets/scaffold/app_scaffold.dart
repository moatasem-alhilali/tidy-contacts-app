part of 'scaffolds.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
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
    this.drawerEnableOpenDragGesture = false,
    super.key,
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
  final EdgeInsetsGeometry? padding;
  final bool drawerEnableOpenDragGesture;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  @override
  Widget build(BuildContext context) {
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
          dividerTheme: DividerThemeData(
            color: footer == null ? null : Colors.transparent,
          ),
        ),
        child: Scaffold(
          key: scaffoldKey,
          drawer: drawer,
          extendBody: true,
          appBar: appBar,
          floatingActionButton: floatingActionButton,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          backgroundColor: scaffoldBackgroundColor ?? context.colors.background,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
          body: Stack(
            children: [
              if (backgroundWidget != null) backgroundWidget!,
              GestureDetectorWidget(
                hapticEnabled: false,
                onTap: () => Utils.disposeKeyboard(context),
                child: SafeArea(
                  top: useTopSafeArea ?? true,
                  bottom: useBottomSafeArea ?? true,
                  child: Padding(
                    padding:
                        padding ??
                        EdgeInsets.only(
                          bottom:
                              context.bottomSpace - context.statusBottomHeight,
                        ),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: bottomNavigationBar,
          persistentFooterButtons: footer != null
              ? [
                  Container(
                    transform: Matrix4.translationValues(
                      0,
                      context.bottomSpace > context.spaces.bottom
                          ? 8
                          : -(context.spaces.bottom - 8),
                      0,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.insets.mn - 8,
                    ),
                    child: footer,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
