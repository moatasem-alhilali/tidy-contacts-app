// import 'dart:math' as math;
// import 'package:flutter/material.dart';
part of '../animations.dart';



/// ---------------------------------------------------------------------------
/// 2) Intro Once: fade + rise + clip reveal + dot pop (plays once)
/// ---------------------------------------------------------------------------
class IsoClickIntroLogo extends StatefulWidget {
  const IsoClickIntroLogo({
    super.key,
    this.style = const IsoClickBrandStyle(),
    this.semanticLabel = 'iSO-Click',
    this.duration = const Duration(milliseconds: 900),
    this.onCompleted,
  });

  final IsoClickBrandStyle style;
  final String semanticLabel;
  final Duration duration;
  final VoidCallback? onCompleted;

  @override
  State<IsoClickIntroLogo> createState() => _IsoClickIntroLogoState();
}

class _IsoClickIntroLogoState extends State<IsoClickIntroLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl =
      AnimationController(vsync: this, duration: widget.duration)..forward();

  late final Animation<double> _fade =
      CurvedAnimation(parent: _ctl, curve: Curves.easeOutCubic);

  late final Animation<double> _rise = Tween<double>(begin: 10, end: 0)
      .animate(CurvedAnimation(parent: _ctl, curve: Curves.easeOutCubic));

  late final Animation<double> _clip =
      CurvedAnimation(parent: _ctl, curve: Curves.easeInOutCubic);

  late final Animation<double> _dotPop = Tween<double>(begin: 0.75, end: 1.0)
      .animate(CurvedAnimation(parent: _ctl, curve: Curves.elasticOut));

  @override
  void initState() {
    super.initState();
    _ctl.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onCompleted?.call();
    });
  }

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
        final clipT = _clip.value;

        final wordmark = IsoClickWordMark(
          style: IsoClickBrandStyle(
            fontFamily: s.fontFamily,
            fontSize: s.fontSize,
            fontWeight: s.fontWeight,
            letterSpacing: s.letterSpacing,
            wordSpacing: s.wordSpacing,
            height: s.height,
            blue: s.blue,
            orange: s.orange,
            dotScale: s.dotScale * _dotPop.value,
            dotDx: s.dotDx,
            dotDy: s.dotDy,
          ),
          semanticLabel: widget.semanticLabel,
        );

        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(0, _rise.value),
            child: ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: clipT, // reveal from left -> right
                child: wordmark,
              ),
            ),
          ),
        );
      },
    );
  }
}

