part of 'slider.dart';

class SliderCustomWidget extends StatefulWidget {
  const SliderCustomWidget({
    required this.value,
    this.backgroundColor,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    super.key,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  State<SliderCustomWidget> createState() => _SliderCustomWidgetState();
}

class _SliderCustomWidgetState extends State<SliderCustomWidget> {
  late double value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackShape: _CustomSliderTrackShape(
          trackHeight: 8.h,
          trackPadding: 10,
          dotColor: context.colors.onSecondaryContainer,
          activeTrackColor: widget.activeColor ?? context.colors.onSecondaryContainer,
          inactiveTrackColor: widget.inactiveColor ?? context.colors.onSecondaryContainer,
        ),
        thumbShape: _CustomThumbShape(),
        thumbColor: Colors.transparent,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
        showValueIndicator: ShowValueIndicator.never,
      ),
      child: Slider(
        value: value,
        max: widget.max,
        min: widget.min,
        divisions: widget.divisions,
        onChanged: (value) => setState(() {
          this.value = value;
          widget.onChanged?.call(value);
        }),
      ),
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(26, 26);

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required Size sizeWithOverflow,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double textScaleFactor,
        required double value,
      }) {
    final double thumbRadius = getPreferredSize(true, isDiscrete).width / 2;

    // Paint for red background circle
    final Paint backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Paint for gray stroke circle
    final Paint circlePaint = Paint()
      ..color = const Color(0xFF8E8E93)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.r;

    // Draw red background circle
    context.canvas.drawCircle(center, thumbRadius, backgroundPaint);

    // Draw stroke circle on top of the red background
    context.canvas.drawCircle(center, thumbRadius, circlePaint);
  }
}


class _CustomSliderTrackShape extends RoundedRectSliderTrackShape {
  const _CustomSliderTrackShape({
    required this.trackHeight,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.trackPadding,
    required this.dotColor,
  });

  final double trackHeight;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color dotColor;
  final double trackPadding;

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required Offset thumbCenter,
        Offset? secondaryOffset,
        bool isEnabled = false,
        bool isDiscrete = false,
        double additionalActiveTrackHeight = 2.0,
      }) {
    final trackWidth = parentBox.size.width;
    final activeTrackRect = Rect.fromLTWH(
      offset.dx,
      thumbCenter.dy - trackHeight / 2,
      thumbCenter.dx - offset.dx,
      trackHeight,
    );

    final inactiveTrackRect = Rect.fromLTWH(
      thumbCenter.dx,
      thumbCenter.dy - trackHeight / 2,
      trackWidth - (thumbCenter.dx - offset.dx),
      trackHeight,
    );

    final Paint activeTrackPaint = Paint()
      ..color = activeTrackColor
      ..style = PaintingStyle.fill;

    final Paint inactiveTrackPaint = Paint()
      ..color = inactiveTrackColor
      ..style = PaintingStyle.fill;

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeTrackRect, const Radius.circular(360)),
      activeTrackPaint,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(inactiveTrackRect, const Radius.circular(360)),
      inactiveTrackPaint,
    );

    double dotSpacing = 12;
    double dotWidth = 2.h;
    double dotHeight = 4.h;
    final Paint dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    for (double i = offset.dx; i < offset.dx + trackWidth; i += dotSpacing) {
      final Rect dotRect = Rect.fromCenter(
        center: Offset(i, thumbCenter.dy + 14),
        width: dotWidth,
        height: dotHeight,
      );
      context.canvas.drawOval(dotRect, dotPaint);
    }
  }
}