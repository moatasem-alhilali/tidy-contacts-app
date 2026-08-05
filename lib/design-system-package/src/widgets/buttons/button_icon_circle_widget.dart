part of 'buttons.dart';

class ButtonIconCircleWidget extends StatelessWidget {
  const ButtonIconCircleWidget({
    required this.icon,
    this.color,
    this.iconColor,
    this.onPressed,
    this.disable,
    this.size,
    this.iconSize,
    this.quarterTurns = 0,
    this.padding,
    this.fromPackage = false,
    this.isSvgNetwork = false,
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
  final bool fromPackage;
  final bool isSvgNetwork;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 48.h,
      width: size ?? 48.h,
      decoration: BoxDecoration(
        color: color ?? context.colors.secondary,
        borderRadius: BorderRadius.all(context.corners.rc360),
      ),
      child: IconButton(
        padding: EdgeInsets.all(padding ?? 6),
        onPressed: true == disable ? null : onPressed,
        icon: isSvgNetwork
            ? ImageSvgNetwork(
                icon,
                color: iconColor ?? context.colors.onPrimary,
                height: iconSize,
                width: iconSize,
                // fromPackage: fromPackage,
              )
            : ImageSvgAsset(
                icon,
                color: iconColor ?? context.colors.onPrimary,
                height: iconSize,
                width: iconSize,
                fromPackage: fromPackage,
              ).rotate(quarterTurns: quarterTurns),
      ),
    );
  }
}
