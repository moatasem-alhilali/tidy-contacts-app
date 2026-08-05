part of 'switch.dart';

abstract class BaseSwitch extends StatelessWidget {
  const BaseSwitch({
    required this.onChanged,
    required this.value,
    super.key,
    this.isActive = true,
    this.content,
    this.onColor,
    this.offColor,
    this.width,
    this.disableColor,
  });

  final bool isActive;
  final VoidCallback onChanged;
  final Widget? content;
  final bool value;
  final Color? onColor;
  final Color? offColor;
  final Color? disableColor;
  final double? width;

  @protected
  Widget baseSwitchBuild({required BuildContext context, Widget? content}) =>
      AnimatedOpacity(
        opacity: false == isActive ? 0.3 : 1,
        duration: const Duration(milliseconds: 500),
        child: GestureDetector(
          onTap: isActive ? onChanged : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: width ?? 60,
            height: 31,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  context.corners.rc,
                ),
                border: Border.all(
                  color: value
                       ? onColor ?? context.colors.onTertiaryContainer
                      : offColor ?? context.colors.tertiaryContainer,
                  width: 2,
                ),
                color: value
                     ? onColor ?? context.colors.onTertiaryContainer
                    : offColor ?? context.colors.primary),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOutSine,
                  right: value
                      ? width != null
                          ? (width! / 2.3)
                          : 25.0
                      : 0.0,
                  left: value
                      ? 0.0
                      : width != null
                          ? (width! / 2.3)
                          : 25.0,
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    child: content ?? const SizedBox.shrink(),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOutSine,
                  left: value
                      ? width != null
                          ? (width! / 2)
                          : 30.0
                      : 0.0,
                  right: value
                      ? 0.0
                      : width != null
                          ? (width! / 2)
                          : 30.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      height: 22,
                      width: 22,
                      // margin: EdgeInsetsDirectional.only(start: 2,end: 2),
                      decoration: BoxDecoration(
                        color: context.colors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          context.shadows.small,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context);
}
