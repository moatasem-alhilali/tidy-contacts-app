// import 'dart:math' as math;
// import 'package:flutter/material.dart';
part of '../animations.dart';

/// ---------------------------------------------------------------------------
/// 3) Idle: very light breathing (subtle scale + tiny opacity)
/// ---------------------------------------------------------------------------
class IsoClickIdleLogo extends StatefulWidget {
  const IsoClickIdleLogo({
    super.key,
    this.style = const IsoClickBrandStyle(),
    this.semanticLabel = 'iSO-Click',
  });

  final IsoClickBrandStyle style;
  final String semanticLabel;

  @override
  State<IsoClickIdleLogo> createState() => _IsoClickIdleLogoState();
}

class _IsoClickIdleLogoState extends State<IsoClickIdleLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.style;

    return AnimatedBuilder(
      animation: _ctl,
      builder: (context, _) {
        final t = _ctl.value;
        final breath = (math.sin(t * math.pi * 2) + 1) / 2; // 0..1
        final scale = 1.0 + (breath - 0.5) * 0.006; // super tiny
        final opacity = 0.985 + breath * 0.015;

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: IsoClickWordMark(
              style: s,
              semanticLabel: widget.semanticLabel,
            ),
          ),
        );
      },
    );
  }
}

class IsoClickWordMark extends StatelessWidget {
  const IsoClickWordMark({
    super.key,
    this.style = const IsoClickBrandStyle(),
    this.semanticLabel = 'iSO-Click',
  });

  final IsoClickBrandStyle style;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final blueStyle = style.baseTextStyle(style.blue);
    final orangeStyle = style.baseTextStyle(style.orange);

    // We need the orange dot above the "i" in "Click".
    // We'll lay out the text, then position the dot using TextPainter metrics.
    return Semantics(
      label: semanticLabel,
      child: RepaintBoundary(
        child: _WordmarkWithDot(
          blueStyle: blueStyle,
          orangeStyle: orangeStyle,
          dotColor: style.orange,
          dotScale: style.dotScale,
          dotDx: style.dotDx,
          dotDy: style.dotDy,
        ),
      ),
    );
  }
}

class _WordmarkWithDot extends StatelessWidget {
  const _WordmarkWithDot({
    required this.blueStyle,
    required this.orangeStyle,
    required this.dotColor,
    required this.dotScale,
    required this.dotDx,
    required this.dotDy,
  });

  final TextStyle blueStyle;
  final TextStyle orangeStyle;
  final Color dotColor;
  final double dotScale;
  final double dotDx;
  final double dotDy;

  @override
  Widget build(BuildContext context) {
    // Build spans: iSO-Click  (dot handled separately)
    // Colors based on your logo: mostly blue + orange dot + orange "k".
    // If your "k" is not orange, change it here.
    final span = TextSpan(
      children: [
        TextSpan(text: 'iSO-Clic', style: blueStyle),
        TextSpan(text: 'k', style: orangeStyle),
      ],
    );

    // We need the position of the "i" in "Click" to place the dot above it.
    // The string "iSO-Clin" contains that "i" already (the one before 'n').
    // We'll measure prefix up to that "i".
    const prefixUpToI = 'iSO-Cl'; // prefix before "i" in "Click"
    const iChar = 'i';

    return LayoutBuilder(
      builder: (context, constraints) {
        final tpAll = TextPainter(
          text: span,
          textDirection: Directionality.of(context),
          maxLines: 1,
        )..layout();

        // Measure prefix width and "i" width using same style
        final tpPrefix = TextPainter(
          text: TextSpan(text: prefixUpToI, style: blueStyle),
          textDirection: Directionality.of(context),
          maxLines: 1,
        )..layout();

        final tpI = TextPainter(
          text: TextSpan(text: iChar, style: blueStyle),
          textDirection: Directionality.of(context),
          maxLines: 1,
        )..layout();

        // Dot position: center above the "i"
        final iLeft = tpPrefix.width;
        final iCenterX = iLeft + tpI.width / 2;

        // Baseline-ish positioning: use font size heuristic
        final fontSize = blueStyle.fontSize ?? 56;
        final dotRadius = fontSize * 0.085 * dotScale; // tweakable
        final dotY = -fontSize * 0.22 + dotDy; // above the text
        final dotX = iCenterX + dotDx;

        return SizedBox(
          width: tpAll.width,
          height: tpAll.height + fontSize * 0.35,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                top: fontSize * 0.18, // push text down to make room for dot
                child: RichText(text: span),
              ),
              Positioned(
                left: dotX - dotRadius,
                top: fontSize * 0.18 + dotY,
                child: Container(
                  width: dotRadius * 2,
                  height: dotRadius * 2,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
