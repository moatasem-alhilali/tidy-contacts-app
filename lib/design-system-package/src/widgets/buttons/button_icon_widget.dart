part of 'buttons.dart';

class ButtonIconWidget extends StatelessWidget {
  const ButtonIconWidget({
    required this.icon,
    this.color,
    this.background,
    this.onPressed,
    this.disable,
    this.size,
    this.iconSize,
    this.quarterTurns = 0,
    this.padding,
    this.fromPackage = false,
    super.key,
  });

  final Color? color;
  final Color? background;
  final String icon;
  final VoidCallback? onPressed;
  final bool? disable;
  final double? size;
  final double? iconSize;
  final int quarterTurns;
  final double? padding;
  final bool fromPackage;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: true == disable ? 0.2 : 1,
      duration: const Duration(milliseconds: 500),
      child: CircleAvatar(
        backgroundColor: background,
        radius: size,
        child: IconButton(
          padding: EdgeInsets.all(padding ?? 6),
          onPressed: true == disable ? null : onPressed,
          icon: ImageSvgAsset(
            icon,
            color: color,
            height: iconSize,
            width: iconSize,
            fromPackage: fromPackage,
          ).rotate(quarterTurns: quarterTurns),
        ),
      ),
    );
  }
}
