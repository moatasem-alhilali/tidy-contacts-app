part of 'wrappers.dart';

class WrapperDisabledWidget extends StatelessWidget {
  const WrapperDisabledWidget({
    required this.child,
    super.key,
    this.disabled = false,
    this.opacity = 0.5,
    this.opacityDuration = const Duration(milliseconds: 200),
  });

  final Widget child;
  final bool disabled;
  final double opacity;
  final Duration opacityDuration;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disabled,
      child:AnimatedOpacity(
        duration: opacityDuration,
        opacity: !disabled ? 1 : opacity,
        child: child,
      ),
    );
  }
}
