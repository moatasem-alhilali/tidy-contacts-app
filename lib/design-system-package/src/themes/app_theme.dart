import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/src/extensions/extensions.dart';
import 'package:hive_manager/design-system-package/src/utils/app_theme_mode.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;
import 'package:skeletonizer/skeletonizer.dart';

part 'colors/base_colors.dart';
part 'colors/dark_theme_colors.dart';
part 'colors/light_theme_colors.dart';
part 'corners/base_corners.dart';
part 'corners/desktop_corners.dart';
part 'corners/mobile_corners.dart';
part 'corners/tablet_corners.dart';
part 'gradients/base_gradients.dart';
part 'gradients/dark_theme_gradients.dart';
part 'gradients/light_theme_gradients.dart';
part 'insets/base_insets.dart';
part 'insets/desktop_insets.dart';
part 'insets/mobile_insets.dart';
part 'insets/tablet_insets.dart';
part 'shadows/base_shadows.dart';
part 'shadows/dark_theme_shadows.dart';
part 'shadows/light_theme_shadows.dart';
part 'spaces/base_spaces.dart';
part 'spaces/desktop_spaces.dart';
part 'spaces/mobile_spaces.dart';
part 'spaces/tablet_spaces.dart';
part 'text_styles/base_text_style.dart';
part 'text_styles/desktop_text_style.dart';
part 'text_styles/mobile_text_style.dart';
part 'text_styles/tablet_text_style.dart';

@immutable
class AppTheme {
  AppTheme(
    BuildContext context,
    this.themeMode,
    String locale,
    this.fontFamily,
    // this.saudiRiyalFontFamily,
  ) {
    intl.Intl.canonicalizedLocale(locale);
    intl.Intl(locale);
    initializeDateFormatting();
    textStyle = context.responsive(
      desktop: _DesktopTextStyle(),
      tablet: _TabletTextStyle(),
      mobile: _MobileTextStyle(),
    );
    colors = themeMode.mode(_LightThemeColors(), _DarkThemeColors());
    lightBrightness = themeMode.mode(true, false);
    shadows = themeMode.mode(_LightThemeShadows(), _DarkThemeShadows());
    gradients = themeMode.mode(_LightThemeGradients(), _DarkThemeGradients());
    corners = context.responsive(
      desktop: _DesktopCorners(),
      tablet: _TabletCorners(),
      mobile: _MobileCorners(),
    );
    insets = context.responsive(
      desktop: _DesktopInsets(),
      tablet: _TabletInsets(),
      mobile: _MobileInsets(),
    );
    spaces = context.responsive(
      desktop: _DesktopSpaces(),
      tablet: _TabletSpaces(),
      mobile: _MobileSpaces(),
    );
    localeName = intl.Intl.canonicalizedLocale(locale);
  }

  late final BaseTextStyle textStyle;
  late final BaseColors colors;
  late final BaseGradients gradients;
  late final BaseCorners corners;
  late final BaseShadows shadows;
  late final BaseInsets insets;
  late final BaseSpaces spaces;
  late final String localeName;
  late final String fontFamily;
  // late final String saudiRiyalFontFamily;
  late final bool lightBrightness;
  late final AppThemeMode themeMode;

  ThemeData get themeData => ThemeData(
    // Core theme properties
    fontFamily: fontFamily,
    brightness: lightBrightness ? Brightness.light : Brightness.dark,
    useMaterial3: true,

    // Color scheme
    colorScheme: ColorScheme.light(
      brightness: lightBrightness ? Brightness.light : Brightness.dark,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      tertiary: colors.tertiary,
      onTertiary: colors.onTertiary,
      error: colors.error,
      onError: colors.onError,
      primaryContainer: colors.primaryContainer,
      onPrimaryContainer: colors.onPrimaryContainer,
      secondaryContainer: colors.secondaryContainer,
      onSecondaryContainer: colors.onSecondaryContainer,
      tertiaryContainer: colors.tertiaryContainer,
      onTertiaryContainer: colors.onTertiaryContainer,
      errorContainer: colors.errorContainer,
      onErrorContainer: colors.onErrorContainer,
      surface: colors.surface,
      onSurface: colors.onSurface,
      surfaceContainerHighest: colors.surfaceVariant,
      onSurfaceVariant: colors.onSurfaceVariant,
      outline: colors.outline,
      shadow: colors.shadow,
      inverseSurface: colors.inactive,
      onInverseSurface: colors.onInactive,
      primaryFixed: colors.primaryFixed,
      onPrimaryFixed: colors.onPrimaryFixed,
      secondaryFixed: colors.secondaryFixed,
      onSecondaryFixed: colors.onSecondaryFixed,
      tertiaryFixed: colors.tertiaryFixed,
      onTertiaryFixed: colors.onTertiaryFixed,
      surfaceDim: colors.surfaceDim,
    ),

    // Legacy color properties
    primaryColor: colors.primary,
    primaryColorLight: colors.primaryContainer,
    primaryColorDark: colors.primary,
    scaffoldBackgroundColor: colors.background,
    canvasColor: colors.surface,
    cardColor: colors.surface,
    dividerColor: colors.outline,
    focusColor: colors.primary.withOpacity(0.12),
    hoverColor: colors.primary.withOpacity(0.08),
    highlightColor: colors.primary.withOpacity(0.12),
    splashColor: colors.primary.withOpacity(0.12),
    disabledColor: colors.inactive,
    unselectedWidgetColor: colors.onSecondary,
    secondaryHeaderColor: colors.secondaryContainer,
    shadowColor: colors.shadow,
    hintColor: colors.onSecondary,

    // Text theme
    textTheme:
        TextTheme(
          displayLarge: textStyle.displayLarge,
          displayMedium: textStyle.displayMedium,
          displaySmall: textStyle.displaySmall,
          headlineLarge: textStyle.headlineLarge,
          headlineMedium: textStyle.headlineMedium,
          headlineSmall: textStyle.headlineSmall,
          titleLarge: textStyle.titleLarge,
          titleMedium: textStyle.titleMedium,
          titleSmall: textStyle.titleSmall,
          labelLarge: textStyle.labelLarge,
          labelMedium: textStyle.labelMedium,
          labelSmall: textStyle.labelSmall,
          bodyLarge: textStyle.bodyLarge,
          bodyMedium: textStyle.bodyMedium,
          bodySmall: textStyle.bodySmall,
        ).apply(
          displayColor: colors.onSurface,
          bodyColor: colors.onSurface,
          fontFamily: fontFamily,
        ),

    // Icon theme
    iconTheme: IconThemeData(color: colors.onSurface, size: 24),
    primaryIconTheme: IconThemeData(color: colors.onPrimary, size: 24),

    // App bar theme
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: textStyle.titleLarge.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
      iconTheme: IconThemeData(color: colors.onSurface),
      actionsIconTheme: IconThemeData(color: colors.onSurface),
    ),

    // Bottom app bar theme
    bottomAppBarTheme: BottomAppBarThemeData(
      color: colors.surface,
      elevation: 8,
      shadowColor: colors.shadow,
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.onSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Bottom sheet theme
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.brandColor,
        foregroundColor: colors.onPrimary,
        elevation: 2,
        shadowColor: colors.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        textStyle: textStyle.labelLarge.copyWith(fontFamily: fontFamily),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.brandColor,
        foregroundColor: colors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        textStyle: textStyle.labelLarge.copyWith(fontFamily: fontFamily),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.brandColor,
        side: BorderSide(color: colors.brandColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        textStyle: textStyle.labelLarge.copyWith(
          fontFamily: fontFamily,
          color: colors.onPrimary,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: colors.brandColor,
        foregroundColor: colors.onPrimary,
        textStyle: textStyle.labelLarge.copyWith(
          fontFamily: fontFamily,
          color: colors.onPrimary,
        ),
      ),
    ),

    // Icon button theme
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colors.onPrimary,
        backgroundColor: colors.brandColor,
        iconSize: 18.sp,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    ),

    // Floating action button theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.brandColor,
      foregroundColor: colors.onPrimary,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    ),

    // Card theme
    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 2,
      shadowColor: colors.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: colors.surfaceVariant,
      selectedColor: colors.primaryContainer,
      disabledColor: colors.inactive,
      labelStyle: textStyle.labelMedium.copyWith(
        fontFamily: fontFamily,
        color: colors.onPrimary,
      ),
      secondaryLabelStyle: textStyle.labelMedium.copyWith(
        fontFamily: fontFamily,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.brandColor;
        }
        return colors.surface;
      }),
      checkColor: WidgetStateProperty.all(colors.onPrimary),
      side: BorderSide(color: colors.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return colors.surface;
      }),
      overlayColor: WidgetStateProperty.all(colors.primary.withOpacity(0.12)),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.onPrimary;
        }
        return colors.onSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return colors.surfaceVariant;
      }),
    ),

    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: colors.primary,
      inactiveTrackColor: colors.surfaceVariant,
      thumbColor: colors.primary,
      overlayColor: colors.primary.withOpacity(0.12),
      valueIndicatorColor: colors.primary,
      valueIndicatorTextStyle: textStyle.labelSmall.copyWith(
        color: colors.onPrimary,
      ),
    ),

    // Progress indicator theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colors.primary,
      linearTrackColor: colors.surfaceVariant,
      circularTrackColor: colors.surfaceVariant,
    ),

    // Tab bar theme
    tabBarTheme: TabBarThemeData(
      labelColor: colors.primary,
      unselectedLabelColor: colors.onSecondary,
      indicatorColor: colors.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: textStyle.labelLarge.copyWith(fontFamily: fontFamily),
      unselectedLabelStyle: textStyle.labelMedium.copyWith(
        fontFamily: fontFamily,
      ),
    ),

    // Navigation bar theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colors.surface,
      indicatorColor: colors.primaryContainer,
      labelTextStyle: WidgetStateProperty.all(
        textStyle.labelSmall.copyWith(fontFamily: fontFamily),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colors.primary);
        }
        return IconThemeData(color: colors.onSecondary);
      }),
    ),

    // Navigation rail theme
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: colors.surface,
      selectedIconTheme: IconThemeData(color: colors.primary),
      unselectedIconTheme: IconThemeData(color: colors.onSecondary),
      selectedLabelTextStyle: textStyle.labelSmall.copyWith(
        color: colors.primary,
      ),
      unselectedLabelTextStyle: textStyle.labelSmall.copyWith(
        color: colors.onSecondary,
      ),
      indicatorColor: colors.primaryContainer,
    ),

    // Drawer theme
    drawerTheme: DrawerThemeData(
      backgroundColor: colors.surface,
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16.r)),
      ),
    ),

    // Navigation drawer theme
    navigationDrawerTheme: NavigationDrawerThemeData(
      backgroundColor: colors.surface,
      indicatorColor: colors.primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return textStyle.labelMedium.copyWith(
            color: colors.primary,
            fontFamily: fontFamily,
          );
        }
        return textStyle.labelMedium.copyWith(
          color: colors.onSurface,
          fontFamily: fontFamily,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colors.primary);
        }
        return IconThemeData(color: colors.onSurface);
      }),
    ),

    // List tile theme
    listTileTheme: ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: insets.xl,
        vertical: insets.md,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(corners.rb)),
      tileColor: colors.surface,
      textColor: colors.onSurface,
      iconColor: colors.onSurface,
      selectedTileColor: colors.primaryContainer,
      selectedColor: colors.primary,
    ),

    // Divider theme
    dividerTheme: DividerThemeData(
      color: colors.outline,
      thickness: 0.5,
      space: 1,
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: colors.surface,
      elevation: 24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      titleTextStyle: textStyle.headlineSmall.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
      contentTextStyle: textStyle.bodyMedium.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
    ),

    // Snack bar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.darkGray,
      contentTextStyle: textStyle.bodyMedium.copyWith(
        color: colors.white,
        fontFamily: fontFamily,
      ),
      actionTextColor: colors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    ),

    // Popup menu theme
    popupMenuTheme: PopupMenuThemeData(
      color: colors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      textStyle: textStyle.bodyMedium.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: colors.darkGray,
        borderRadius: BorderRadius.circular(4.r),
      ),
      textStyle: textStyle.bodySmall.copyWith(
        color: colors.white,
        fontFamily: fontFamily,
      ),
    ),

    // Expansion tile theme
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: colors.surface,
      collapsedBackgroundColor: colors.surface,
      textColor: colors.onSurface,
      collapsedTextColor: colors.onSurface,
      iconColor: colors.onSurface,
      collapsedIconColor: colors.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    ),

    // Data table theme
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(colors.surfaceVariant),
      dataRowColor: WidgetStateProperty.all(colors.surface),
      headingTextStyle: textStyle.labelLarge.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
      dataTextStyle: textStyle.bodyMedium.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
      dividerThickness: 0.5,
      horizontalMargin: 16.w,
      columnSpacing: 16.w,
    ),

    // Badge theme
    badgeTheme: BadgeThemeData(
      backgroundColor: colors.error,
      textColor: colors.onError,
      textStyle: textStyle.labelSmall.copyWith(
        color: colors.onError,
        fontFamily: fontFamily,
      ),
    ),

    // Banner theme
    bannerTheme: MaterialBannerThemeData(
      backgroundColor: colors.surfaceVariant,
      contentTextStyle: textStyle.bodyMedium.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
      // actionTextStyle is not a valid parameter in the new MaterialBannerThemeData
      // surfaceTintColor, shadowColor, dividerColor, elevation, padding, leadingPadding are available if needed
    ),
    // Search bar theme
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStateProperty.all(colors.surfaceVariant),
      textStyle: WidgetStateProperty.all(
        textStyle.bodyMedium.copyWith(
          color: colors.onSurface,
          fontFamily: fontFamily,
        ),
      ),
      hintStyle: WidgetStateProperty.all(
        textStyle.bodyMedium.copyWith(
          color: colors.onSecondary,
          fontFamily: fontFamily,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    ),

    // Search view theme
    searchViewTheme: SearchViewThemeData(
      backgroundColor: colors.surface,
      headerTextStyle: textStyle.titleLarge.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
      headerHintStyle: textStyle.bodyMedium.copyWith(
        color: colors.onSecondary,
        fontFamily: fontFamily,
      ),
    ),

    // Segmented button theme
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.onPrimary;
          }
          return colors.onSurface;
        }),
        side: WidgetStateProperty.all(BorderSide(color: colors.outline)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      ),
    ),

    // Toggle buttons theme
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: colors.onSurface,
      selectedColor: colors.primary,
      fillColor: colors.primaryContainer,
      borderColor: colors.outline,
      selectedBorderColor: colors.primary,
      borderRadius: BorderRadius.circular(8.r),
      textStyle: textStyle.labelLarge.copyWith(fontFamily: fontFamily),
    ),

    // Menu theme
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(colors.surface),
        elevation: WidgetStateProperty.all(8),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      ),
    ),

    // Menu button theme
    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(colors.surface),
        foregroundColor: WidgetStateProperty.all(colors.onSurface),
        textStyle: WidgetStateProperty.all(
          textStyle.bodyMedium.copyWith(fontFamily: fontFamily),
        ),
      ),
    ),

    // Menu bar theme
    menuBarTheme: MenuBarThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(colors.surface),
        elevation: WidgetStateProperty.all(2),
      ),
    ),

    // Dropdown menu theme
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(colors.surface),
        elevation: WidgetStateProperty.all(8),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: colors.grey),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: colors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
          color: colors.onSecondary,
        ),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
          color: colors.primary,
        ),
      ),
      textStyle: textStyle.bodyMedium.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: colors.primary, width: 2.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: colors.error, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: colors.error, width: 2.w),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      hintStyle: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 14.sp,
        color: colors.onSecondary,
      ),
      labelStyle: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 14.sp,
        color: colors.primary,
      ),
      errorStyle: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 12.sp,
        color: colors.error,
      ),
    ),

    // Text selection theme
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colors.primary,
      selectionHandleColor: colors.primary,
      selectionColor: colors.primary.withOpacity(0.3),
    ),

    // Date picker theme
    datePickerTheme: DatePickerThemeData(
      backgroundColor: colors.surface,
      yearStyle: textStyle.labelLarge.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
      weekdayStyle: textStyle.labelLarge.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
      dayStyle: textStyle.labelLarge.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
      surfaceTintColor: colors.primary,
      headerForegroundColor: colors.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(corners.rs)),
      cancelButtonStyle: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: insets.xl * 2, vertical: insets.md),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(corners.rm)),
        ),
        foregroundColor: WidgetStatePropertyAll(colors.onSurface),
        backgroundColor: WidgetStatePropertyAll(colors.surfaceVariant),
        textStyle: WidgetStatePropertyAll(
          textStyle.labelLarge.copyWith(fontFamily: fontFamily),
        ),
      ),
      confirmButtonStyle: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: insets.xl * 2, vertical: insets.md),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.all(corners.rm)),
        ),
        foregroundColor: WidgetStatePropertyAll(colors.onPrimary),
        backgroundColor: WidgetStatePropertyAll(colors.primary),
        textStyle: WidgetStatePropertyAll(
          textStyle.labelLarge.copyWith(fontFamily: fontFamily),
        ),
      ),
    ),

    // Time picker theme
    timePickerTheme: TimePickerThemeData(
      backgroundColor: colors.surface,
      hourMinuteTextStyle: textStyle.headlineMedium.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
      hourMinuteColor: colors.surfaceVariant,
      hourMinuteTextColor: colors.onSurface,
      dayPeriodTextStyle: textStyle.labelLarge.copyWith(
        color: colors.onSurface,
        fontFamily: fontFamily,
      ),
      dayPeriodColor: colors.surfaceVariant,
      dayPeriodTextColor: colors.onSurface,
      dialHandColor: colors.primary,
      dialBackgroundColor: colors.surfaceVariant,
      dialTextColor: colors.onSurface,
      entryModeIconColor: colors.onSurface,
    ),

    // Extensions
    extensions: [
      SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: colors.baseColor,
          highlightColor: colors.highlightColor,
          end: AlignmentDirectional.centerStart,
          begin: AlignmentDirectional.centerEnd,
          duration: const Duration(milliseconds: 1000),
        ),
        containersColor: colors.primary,
        textBorderRadius: TextBoneBorderRadius(BorderRadius.all(corners.rc360)),
      ),
    ],
  );
}
