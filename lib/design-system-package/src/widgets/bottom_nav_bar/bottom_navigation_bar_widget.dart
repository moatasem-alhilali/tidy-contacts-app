part of 'bottom_navigation_bar.dart';

class NavigationItemWidget extends StatelessWidget {
  const NavigationItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final NavigationBarEntity item;
  final bool isSelected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        padding:
            isSelected ? EdgeInsets.all(context.insets.sm) : EdgeInsets.zero,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primary : Colors.transparent,
          borderRadius: BorderRadius.all(context.corners.rc360),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 48.h,
                width: 48.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.tertiary
                      : context.colors.primary,
                  borderRadius: BorderRadius.all(context.corners.rc360),
                ),
                child: Center(
                  child: ImageCacheNetworkSVG(
                      isSelected ? item.selectedIcon : item.icon,
                      width: 24.h,
                      height: 24.h,
                      color: context.colors.onPrimary),
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: context.insets.md,
                  end: context.insets.mn,
                ),
                child: TextWidget(
                  item.text,
                  style: context.textStyles.titleSmall.copyWith(
                    color: context.colors.onPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              crossFadeState: isSelected
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}
