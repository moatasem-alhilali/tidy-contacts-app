// import 'dart:math' as math;
// import 'package:flutter/material.dart';
part of '../animations.dart';

/// ---------------------------------------------------------------------------
/// IsoClick Text Logo (NO IMAGE)
/// - Fully text-based
/// - Tunable to match your exact wordmark (font family, spacing, weights)
/// - Three variants:
///   1) IsoClickLoadingLogo   (infinite)
///   2) IsoClickIntroLogo     (one-shot)
///   3) IsoClickIdleLogo      (very subtle)
/// ---------------------------------------------------------------------------

@immutable
class IsoClickBrandStyle {
  const IsoClickBrandStyle({
    this.fontFamily,
    this.fontSize = 56,
    this.fontWeight = FontWeight.w700,
    this.letterSpacing = -0.8,
    this.wordSpacing = 0,
    this.height = 1.0,
    this.blue = const Color(0xFF5C78B8),
    this.orange = const Color(0xFFF05A2A),
    this.dotScale = 1.0,
    this.dotDx = 0.0,
    this.dotDy = 0.0,
  });

  /// Put your real logo font here to get “exact”.
  final String? fontFamily;

  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;
  final double wordSpacing;
  final double height;

  final Color blue;
  final Color orange;

  /// Orange dot above the second "i"
  final double dotScale;
  final double dotDx;
  final double dotDy;

  TextStyle baseTextStyle(Color color) => TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    height: height,
    color: color,
  );
}
