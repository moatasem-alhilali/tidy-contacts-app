part of 'extensions.dart';

extension WidgetExtension on Widget {
  /// add rotation to parent widget
  Widget rotate({
    required int quarterTurns,
    bool transformHitTests = true,
    Offset? origin,
  }) =>
      RotatedBox(quarterTurns: quarterTurns, child: this);

  Widget transformRotate({
    required double angle,
    bool transformHitTests = true,
    Offset? origin,
  }) =>
      Transform.rotate(
        angle: angle,
        child: this,
      );

  /// add rotation to parent widget
  Widget get tr => Builder(
        builder: (context) => RotatedBox(
          quarterTurns: Directionality.of(context) == TextDirection.ltr ? 0 : 2,
          child: this,
        ),
      );
  //TODO: enhance and replace it with tr ext
  Widget get translate => Builder(
        builder: (context) => RotatedBox(
          quarterTurns: Directionality.of(context) == TextDirection.rtl ? 0 : 2,
          child: this,
        ),
      );
}
