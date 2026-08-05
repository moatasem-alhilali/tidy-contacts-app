part of 'indicators.dart';

class IndicatorLinearProgressWithTimerWidget extends StatefulWidget {
  const IndicatorLinearProgressWithTimerWidget({
    required this.duration,
    required this.progressColor,
    super.key,
  });

  final int duration;
  final Color progressColor;

  @override
  _IndicatorLinearProgressWithTimerWidgetState createState() =>
      _IndicatorLinearProgressWithTimerWidgetState();
}

class _IndicatorLinearProgressWithTimerWidgetState
    extends State<IndicatorLinearProgressWithTimerWidget> {
  late Timer _timer;
  double _progressValue = 0;

  @override
  void initState() {
    super.initState();

    final steps = (widget.duration * 1000) ~/ 50;

    final stepIncrement = 1.0 / steps;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progressValue += stepIncrement;
      });

      if (_progressValue >= 1.0) {
        _progressValue = 1.0;
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: LinearProgressIndicator(
        value: _progressValue,
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(widget.progressColor),
      ),
    );
  }
}
