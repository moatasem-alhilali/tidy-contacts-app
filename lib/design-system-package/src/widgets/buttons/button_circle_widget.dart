part of 'buttons.dart';

class ButtonCircleWidget extends StatelessWidget {
  const ButtonCircleWidget({
    this.icon,
    this.iconData,
    this.onTap,
    this.color,
    this.radius,
    this.iconSize,
    this.iconColor,
    this.fit,
    super.key,
  });

  final String? icon;
  final IconData? iconData;
  final GestureTapCallback? onTap;
  final Color? color;
  final Color? iconColor;
  final double? radius;
  final double? iconSize;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(radius ?? 30.h),
      color: color ?? context.colors.primary,
      child: SizedBox(
        height: radius ?? 30.h,
        width: radius ?? 30.h,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius ?? 30.h),
          child: Center(
            child: iconData != null
                ? Icon(
                    iconData,
                    size: iconSize ?? 15.h,
                    color: iconColor ?? context.colors.onPrimary,
                  )
                : ImageWidget(
                    icon,
                    width: iconSize ?? 15.h,
                    height: iconSize ?? 15.h,
                    color: iconColor ?? context.colors.onPrimary,
                    fit: fit,
                  ),
          ),
        ),
      ),
    );
  }
}
