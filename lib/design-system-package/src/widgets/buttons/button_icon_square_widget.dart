part of 'buttons.dart';

class ButtonIconSquareWidget extends StatelessWidget {
  const ButtonIconSquareWidget({
    required this.icon,
    this.color,
    this.iconColor,
    this.onPressed,
    this.disable,
    this.size,
    this.iconSize,
    this.quarterTurns = 0,
    this.padding,
    this.borderRadius,
    super.key,
  });

  final Color? color;
  final Color? iconColor;
  final String icon;
  final VoidCallback? onPressed;
  final bool? disable;
  final double? size;
  final double? iconSize;
  final int quarterTurns;
  final double? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 48.h,
      width: size ?? 48.h,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF343434),
        borderRadius: borderRadius ?? BorderRadius.all(context.corners.rc360),
      ),
      child: IconButton(
        padding: EdgeInsets.all(padding ?? 6),
        onPressed: true == disable ? null : onPressed,
        icon: ImageSvgAsset(
          icon,
          color: iconColor,
          height: iconSize,
          width: iconSize,
        ).rotate(quarterTurns: quarterTurns),
      ),
    );
  }
}
