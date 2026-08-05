part of '../animations.dart';

class IsoClickLoadingLogo extends StatefulWidget {
  const IsoClickLoadingLogo({
    super.key,
    this.style = const IsoClickBrandStyle(),
    this.semanticLabel = 'iSO-Click loading',
    this.intensity = 1.0,
    this.enableShimmer = true,
    this.cycle = const Duration(milliseconds: 900), // أسرع
  });

  final IsoClickBrandStyle style;
  final String semanticLabel;

  /// 0.6..1.4 (ارتفاع القفزة وتأثيرها)
  final double intensity;

  final bool enableShimmer;

  /// مدة دورة القفزة
  final Duration cycle;

  @override
  State<IsoClickLoadingLogo> createState() => _IsoClickLoadingLogoState();
}

class _IsoClickLoadingLogoState extends State<IsoClickLoadingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl = AnimationController(
    vsync: this,
    duration: widget.cycle,
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
        final t = _ctl.value; // 0..1

        // قفزة واقعية (سريعة) + impact + settle
        final H = s.fontSize * 0.55 * widget.intensity; // ارتفاع القفزة
        final dy = _jumpY(t) * H; // negative up

        // squash/stretch للحرف فقط (واقعي)
        final sx = _jumpScaleX(t);
        final sy = _jumpScaleY(t);

        // shimmer اختياري
        final shimmerX = t * 2 - 1; // -1..1

        Widget child = IsoClickWordMarkAnimatedK(
          style: s,
          semanticLabel: widget.semanticLabel,
          kDy: dy,
          kScaleX: sx,
          kScaleY: sy,
        );

        if (widget.enableShimmer) {
          child = IsoClickTextShimmerMask(progress: shimmerX, child: child);
        }

        // الشعار ثابت بالكامل — لا scale على الكل.
        return child;
      },
    );
  }

  /// Returns value in [-1..+something small], negative = up.
  double _jumpY(double t) {
    // Keyframes (Normalized):
    // 0.00-0.12 takeoff to peak
    // 0.12-0.45 hang near peak
    // 0.45-0.72 fall to ground
    // 0.72-0.82 impact (slight overshoot)
    // 0.82-1.00 settle
    if (t < 0.12) {
      final x = Curves.easeOutCubic.transform(t / 0.12);
      return -1.0 * x;
    }
    if (t < 0.45) {
      final x = (t - 0.12) / (0.45 - 0.12);
      // قليل "hang" (قمة مسطحة)
      final hang = Curves.easeInOutSine.transform(x);
      return -1.0 + (hang * 0.08); // -1 .. -0.92
    }
    if (t < 0.72) {
      final x = Curves.easeInCubic.transform((t - 0.45) / (0.72 - 0.45));
      return -0.92 + (0.92 * x); // -0.92 -> 0
    }
    if (t < 0.82) {
      final x = Curves.easeOutCubic.transform((t - 0.72) / (0.82 - 0.72));
      // impact: نزل للأرض ثم overshoot بسيط لتحت
      return 0.10 * x; // 0 -> +0.10
    }
    final x = Curves.easeOutCubic.transform((t - 0.82) / (1.0 - 0.82));
    // settle: رجوع للصفر
    return 0.10 * (1 - x);
  }

  double _jumpScaleX(double t) {
    // widen a bit on impact, slight narrow in air
    final air = _airFactor(t); // 0..1
    final impact = _impactFactor(t); // 0..1
    return (1.0 - air * 0.04) + impact * 0.10;
  }

  double _jumpScaleY(double t) {
    // stretch in air, squash on impact
    final air = _airFactor(t);
    final impact = _impactFactor(t);
    return (1.0 + air * 0.10) - impact * 0.18;
  }

  double _airFactor(double t) {
    // peak around hang (0.12..0.72)
    if (t < 0.12) return Curves.easeOutCubic.transform(t / 0.12);
    if (t < 0.72) return 1;
    return 0;
  }

  double _impactFactor(double t) {
    // impact around 0.72..0.88
    if (t < 0.70) return 0;
    if (t < 0.82) {
      return Curves.easeOutCubic.transform((t - 0.70) / (0.82 - 0.70));
    }
    if (t < 0.92) {
      return 1.0 - Curves.easeOutCubic.transform((t - 0.82) / (0.92 - 0.82));
    }
    return 0;
  }
}

/// Wordmark مضبوط: iSO-Clic + (animated k) + dot فوق i.
/// تثبيت k بالمكان الصحيح عبر قياسات TextPainter (بدون Row baseline مشاكل).
class IsoClickWordMarkAnimatedK extends StatelessWidget {
  const IsoClickWordMarkAnimatedK({
    required this.style,
    required this.kDy,
    required this.kScaleX,
    required this.kScaleY,
    super.key,
    this.semanticLabel = 'iSO-Click',
  });

  final IsoClickBrandStyle style;
  final String semanticLabel;

  final double kDy;
  final double kScaleX;
  final double kScaleY;

  @override
  Widget build(BuildContext context) {
    final blueStyle = style.baseTextStyle(style.blue);
    final kStyle = style.baseTextStyle(style.orange);

    // ✅ الصحيح: iSO-Clic + k
    const prefixText = 'iSO-Clic';
    const kText = 'k';

    // dot فوق i في "Click": prefix قبل i هو "iSO-Cl"
    const prefixUpToI = 'iSO-Cl';
    const iChar = 'i';

    final direction = Directionality.of(context);

    // قياسات النص
    final tpPrefix = TextPainter(
      text: TextSpan(text: prefixText, style: blueStyle),
      textDirection: direction,
      maxLines: 1,
    )..layout();

    final tpK = TextPainter(
      text: TextSpan(text: kText, style: kStyle),
      textDirection: direction,
      maxLines: 1,
    )..layout();

    final tpUpToI = TextPainter(
      text: TextSpan(text: prefixUpToI, style: blueStyle),
      textDirection: direction,
      maxLines: 1,
    )..layout();

    final tpI = TextPainter(
      text: TextSpan(text: iChar, style: blueStyle),
      textDirection: direction,
      maxLines: 1,
    )..layout();

    final lineMetrics = tpPrefix.computeLineMetrics();
    final baseline = lineMetrics.isNotEmpty
        ? lineMetrics.first.baseline
        : (blueStyle.fontSize ?? 56) * 0.8;

    final fontSize = blueStyle.fontSize ?? 56;

    // dot position (centered above the "i")
    final iLeft = tpUpToI.width;
    final iCenterX = iLeft + tpI.width / 2;

    final dotRadius = fontSize * 0.085 * style.dotScale;
    final dotX = iCenterX + style.dotDx;
    final dotY =
        (baseline - fontSize * 0.95) + style.dotDy; // فوق الحرف بشكل طبيعي

    final totalW = tpPrefix.width + tpK.width;
    final totalH = tpPrefix.height + fontSize * 0.45;

    return Semantics(
      label: semanticLabel,
      child: RepaintBoundary(
        child: SizedBox(
          width: totalW,
          height: totalH,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Prefix
              Positioned(
                left: 0,
                top: 0,
                child: RichText(
                  textDirection: direction,
                  text: TextSpan(text: prefixText, style: blueStyle),
                ),
              ),

              // Animated k positioned exactly after prefix
              Positioned(
                left: tpPrefix.width,
                top: 0,
                child: Transform.translate(
                  offset: Offset(0, kDy),
                  child: Transform(
                    alignment: Alignment.bottomLeft,
                    transform: Matrix4.diagonal3Values(kScaleX, kScaleY, 1),
                    child: Text(kText, style: kStyle),
                  ),
                ),
              ),

              // Dot
              Positioned(
                left: dotX - dotRadius,
                top: dotY - dotRadius,
                child: Container(
                  width: dotRadius * 2,
                  height: dotRadius * 2,
                  decoration: BoxDecoration(
                    color: style.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IsoClickTextShimmerMask extends StatelessWidget {
  const IsoClickTextShimmerMask({
    required this.progress,
    required this.child,
    super.key,
    this.intensity = 0.30,
  });

  /// -1..1
  final double progress;
  final Widget child;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        final w = bounds.width;
        final shift = progress * w;
        return LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: intensity),
            Colors.white.withValues(alpha: 0),
          ],
          stops: const [0.42, 0.50, 0.58],
          transform: _IsoClickTranslateGradient(shift),
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

class _IsoClickTranslateGradient extends GradientTransform {
  const _IsoClickTranslateGradient(this.dx);
  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity()..translate(dx);
  }
}
