part of 'extensions.dart';

extension ContextExtensions on BuildContext {
  /// Retrieves the size of the screen using [MediaQuery.of(context).size].
  Size get mediaQuerySize => MediaQuery.sizeOf(this);

  /// Retrieves the view insets of the screen using [MediaQuery.of(context).viewInsets].
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// The height of the screen.
  double get height => mediaQuerySize.height;

  /// The width of the screen.
  double get width => mediaQuerySize.width;

  /// The height of the bottom system padding, adjusted for pixel ratio.
  double get statusBottomHeight =>
      View.of(this).padding.bottom / View.of(this).devicePixelRatio;

  /// The height of space at the bottom.
  double get bottomSpace {
    if (statusBottomHeight > spaces.bottom) {
      return statusBottomHeight;
    } else {
      return statusBottomHeight + spaces.bottom;
    }
  }

  /// The height of the top system padding, adjusted for pixel ratio.
  double get statusTopHeight =>
      View.of(this).padding.top / View.of(this).devicePixelRatio;

  /// Determines the breakpoint based on the screen width.
  /// Returns [Breakpoint.desktop] if width > 834,
  /// [Breakpoint.tablet] if width > 600, otherwise [Breakpoint.mobile].
  Breakpoint get breakpoint {
    if (width > 1024) {
      return Breakpoint.desktop;
    } else if (width > 600) {
      return Breakpoint.tablet;
    }
    return Breakpoint.mobile;
  }

  /// Returns true if the screen size is categorized as desktop.
  bool get isDesktop => breakpoint == Breakpoint.desktop;

  /// Returns true if the screen size is categorized as tablet.
  bool get isTablet => breakpoint == Breakpoint.tablet;

  /// Returns true if the screen size is categorized as mobile.
  bool get isMobile => breakpoint == Breakpoint.mobile;

  /// Returns a value based on the current screen size.
  /// Uses [desktop] for desktop, [tablet] for tablet (or desktop if tablet is null),
  /// and [mobile] for mobile.
  T responsive<T>({required T desktop, T? tablet, required T mobile}) {
    if (isDesktop) {
      return desktop;
    } else if (isTablet) {
      return mobile;
    }
    return mobile;
  }

  /// Group of theme-related properties.

  /// Retrieves the [AppTheme] associated with the current context.
  AppTheme get designSystem => DesignSystemApp.of(this);

  /// Returns the colors from the designSystem.
  BaseColors get designSystemColor => designSystem.colors;

  /// Returns the theme data from the context.
  ThemeData get theme => Theme.of(this);

  /// Returns the color scheme from the theme.
  BaseColors get colors => designSystem.colors;

  /// Returns the base text styles from the theme.
  BaseTextStyle get textStyles => designSystem.textStyle;

  /// Returns the base gradients from the theme.
  BaseGradients get gradients => designSystem.gradients;

  /// Returns the base corners (radii) from the theme.
  BaseCorners get corners => designSystem.corners;

  /// Returns the base shadows from the theme.
  BaseShadows get shadows => designSystem.shadows;

  /// Returns the base insets (paddings) from the theme.
  BaseInsets get insets => designSystem.insets;

  BaseSpaces get spaces => designSystem.spaces;

  /// Returns true if the current language is English.
  bool get isEnglish => designSystem.isEnglish;

  /// Returns the alignment based on the current language direction.
  /// Aligns to the left for English, right for non-English.
  AlignmentGeometry get alignment =>
      isEnglish ? Alignment.centerLeft : Alignment.centerRight;

  /// Returns the text align based on the current language direction.
  /// Aligns to the left for English, right for non-English.
  TextAlign get textAlign => isEnglish ? TextAlign.left : TextAlign.right;

  T mode<T>(T light, T dark) {
    if (designSystem.themeMode == AppThemeMode.dark) {
      return dark;
    }
    return light;
  }

  T language<T>(T ar, T en) {
    if (isEnglish) {
      return en;
    }
    return ar;
  }

  Widget levelDeviceSpec({
    required Future<bool>? future,
    Widget high = const SizedBox.shrink(),
    Widget weak = const SizedBox.shrink(),
  }) {
    return FutureBuilder<bool>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // log(snapshot.data);
        return (snapshot.data ?? false) ? weak : high;
      },
    );
  }
}
