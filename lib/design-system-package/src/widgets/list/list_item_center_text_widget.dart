part of 'list_widgets.dart';

class ListItemCenterTextWidget extends StatelessWidget {
  const ListItemCenterTextWidget({
    required this.index,
    this.title,
    this.selectedIndex,
    super.key,
  });

  final int? selectedIndex;
  final int index;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageSvgAsset(
          '  Assets.icons.check.path',
          color: context.colors.onPrimaryContainer.withOpacity(
            selectedIndex == index ? 1 : 0,
          ),
          height: 24.h,
          width: 24.h,
        ),
        SizedBox(width: context.insets.sm),
        TextWidget(
          title,
          style: context.textStyles.titleSmall.copyWith(
            color: context.colors.onPrimaryContainer,
          ),
        ),
        SizedBox(height: 24.h, width: 24.h),
      ],
    );
  }
}
