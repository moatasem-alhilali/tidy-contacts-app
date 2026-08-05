part of 'slider.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({
    required this.value,
    required this.min,
    required this.max,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    super.key,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SliderTheme(
      data: SliderThemeData(
        trackShape: _CustomTrackShape(
          trackHeight: 10,
          trackPadding: 0,
          activeTrackColor: widget.activeColor ?? context.colors.primaryFixed,
          inactiveTrackColor:
              widget.inactiveColor ?? context.colors.onSecondaryContainer,
          isRtl: isRtl,
        ),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: Slider(
        value: value,
        max: widget.max,
        min: widget.min,
        onChanged: widget.onChanged != null
            ? (val) => setState(() {
                  value = val;
                  widget.onChanged?.call(val);
                })
            : null,
      ),
    );
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  const _CustomTrackShape({
    required this.trackHeight,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.trackPadding,
    required this.isRtl,
  });

  final double trackHeight;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final double trackPadding;
  final bool isRtl;

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
    final trackWidth = parentBox.size.width - 2 * trackPadding;
    final trackLeft = offset.dx + trackPadding;
    final trackRight = trackLeft + trackWidth;

    final activeTrackRect = isRtl
        ? Rect.fromLTWH(thumbCenter.dx, thumbCenter.dy - trackHeight / 2,
            trackRight - thumbCenter.dx, trackHeight)
        : Rect.fromLTWH(trackLeft, thumbCenter.dy - trackHeight / 2,
            thumbCenter.dx - trackLeft, trackHeight);

    final inactiveTrackRect = isRtl
        ? Rect.fromLTWH(trackLeft, thumbCenter.dy - trackHeight / 2,
            thumbCenter.dx - trackLeft, trackHeight)
        : Rect.fromLTWH(thumbCenter.dx, thumbCenter.dy - trackHeight / 2,
            trackRight - thumbCenter.dx, trackHeight);

    final activeTrackPaint = Paint()
      ..color = activeTrackColor
      ..style = PaintingStyle.fill;

    final inactiveTrackPaint = Paint()
      ..color = inactiveTrackColor
      ..style = PaintingStyle.fill;

    final fullTrackRect = Rect.fromLTWH(
      trackLeft,
      thumbCenter.dy - trackHeight / 2,
      trackWidth,
      trackHeight,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(fullTrackRect, const Radius.circular(360)),
      inactiveTrackPaint,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeTrackRect, const Radius.circular(360)),
      activeTrackPaint,
    );
  }
}
