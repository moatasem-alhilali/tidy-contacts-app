part of '../app_theme.dart';

@immutable
class _DarkThemeGradients extends BaseGradients {
  @override
  // TODO: Confirm it in the design system.
  final LinearGradient primary = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.black.withOpacity(0),
      Colors.black.withOpacity(0.85),
    ],
  );
  @override
  final LinearGradient accent = LinearGradient(
    begin: Alignment(1.00, 0.00),
    end: Alignment(-1, 0),
    colors: [
      Color(0x0),
      Color(0xFFFFFFFF),
    ],
  );

  @override
  final LinearGradient background = LinearGradient(
    begin: Alignment(1.00, 0.00),
    end: Alignment(-1, 0),
    colors: [
      Color(0x1AFFFFFF),
      Color(0xFFFFFFFF),
    ],
  );
  @override
  final LinearGradient button = LinearGradient(
    begin: AlignmentDirectional(-0.69, -0.72),
    end: AlignmentDirectional(0.69, 0.72),
    colors: [
      Color(0xFF1A1A1A),
      Color(0xFF1A1A1A),
    ],
  );

  @override
  final LinearGradient card = LinearGradient(
    begin: const AlignmentDirectional(0.91, -0.41),
    end: const AlignmentDirectional(-0.91, 0.41),
    colors: [
      Colors.black,
      Colors.black,
    ],
  );
  @override
  // TODO: implement dividerGradient
  final LinearGradient divider = LinearGradient(colors: []);

  @override
  final LinearGradient error = LinearGradient(
    begin: const AlignmentDirectional(0.91, -0.41),
    end: const AlignmentDirectional(-0.91, 0.41),
    colors: [
      const Color(0xFF000000),
      const Color(0xFF000000),
    ],
  );

  @override
  final LinearGradient red = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF57474),
      Color(0xFFF3C7C7),
    ],
  );

  @override
  // TODO: implement footerGradient
  final LinearGradient footer = LinearGradient(colors: []);

  @override
  // TODO: implement headerGradient
  final LinearGradient header = LinearGradient(colors: []);

  @override
  // TODO: implement highlightGradient
  final LinearGradient highlight = LinearGradient(colors: []);

  @override
  // TODO: implement infoGradient
  final LinearGradient info = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF283B2D),
      Color(0xFF29362D),
      Color(0xFF29322B),
    ],
  );
  @override
  final LinearGradient warning = LinearGradient(
    begin: Alignment(0.91, -0.41),
    end: Alignment(-0.91, 0.41),
    colors: [
      Colors.white.withOpacity(0.2),
      const Color(0xFFF2C94C).withOpacity(0.2),
    ],
  );
  @override
  final LinearGradient modal = const LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color(0x28A745),
      Color(0xFF28A745),
    ],
  );
  @override
  // TODO: implement overlayGradient
  final LinearGradient overlay = LinearGradient(colors: []);

  @override
  // TODO: implement secondaryGradient
  final LinearGradient secondary = LinearGradient(colors: []);

  @override
  // TODO: implement shadowGradient
  final LinearGradient shadow = LinearGradient(colors: []);

  @override
  // TODO: implement splashGradient
  final LinearGradient splash = LinearGradient(colors: []);

  @override
  // TODO: Fix successGradient
  final LinearGradient success = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x4C28A745),
      Color(0x1328A745),
    ],
  );

  @override
  // TODO: implement tertiaryGradient
  final LinearGradient tertiary = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color(0x1AA0A7AF),
      Color(0x1AA0A7AF),
    ],
  );

  @override
  // TODO: implement textGradient
  final LinearGradient text = LinearGradient(colors: []);

  @override
  LinearGradient get transparent => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.transparent,
        ],
      );

  @override
  LinearGradient get chart => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF28A745).withValues(alpha: 0.6),
          const Color(0x03ffffff),
        ],
      );

  @override
   LinearGradient get tent => const LinearGradient(
        colors: [
          Colors.transparent,
          Colors.transparent,
          Color(0x800c0c0c),
        ],
        begin: Alignment.center,
        end: Alignment.bottomCenter,
      );
}
