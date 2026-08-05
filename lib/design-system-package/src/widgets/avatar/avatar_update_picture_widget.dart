part of 'avatar.dart';

class AvatarUpdatePictureWidget extends StatelessWidget {
  const AvatarUpdatePictureWidget({
    this.image,
    this.title,
    this.subtitle,
    this.size,
    this.onTap,
    super.key,
  });

  final String? image;
  final String? title;
  final String? subtitle;
  final double? size;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              AvatarCircularWidget(image: image, size: 35),
              PositionedDirectional(
                end: 0,
                bottom: context.insets.md,
                // child: Assets.icons.camera.svg(),
                child: const SizedBox(),
              ),
            ],
          ),
        ),
        SizedBox(height: context.insets.lg),
        TextWidget(
          title,
          style: context.textStyles.titleSmall.copyWith(
            color: context.colors.onPrimary,
          ),
        ),
        if (true == subtitle?.isNotEmpty) ...[
          SizedBox(height: context.insets.sm),
          TextWidget(
            subtitle,
            style: context.textStyles.labelLarge.copyWith(
              color: context.colors.onSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
