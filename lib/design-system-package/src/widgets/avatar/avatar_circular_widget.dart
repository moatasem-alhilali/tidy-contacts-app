part of 'avatar.dart';

class AvatarCircularWidget extends StatelessWidget {
  const AvatarCircularWidget({
    this.image,
    this.title,
    this.subtitle,
    this.size,
    super.key,
  });

  final String? image;
  final String? title;
  final String? subtitle;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(context.insets.sm),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.colors.inactive,
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: size ?? 42,
              backgroundColor: context.colors.inactive,
              // child: image == null
              //     ? Assets.icons.avatar.svg(
              //         width: 28.h,
              //         height: 28.h,
              //       )
              //     : ImageWidget(
              //         image,
              //         isCircle: true,
              //         width: (size ?? 30.h) * 1.5,
              //         height: (size ?? 30.h) * 1.5,
              //         fit: BoxFit.cover,
              //       ),
            ),
          ),),
        SizedBox(height: context.insets.sm),
        TextWidget(
          title,
          style: context.textStyles.headlineSmall
                ?.copyWith(color: context.colors.onPrimary),
          ),
        SizedBox(height: context.insets.sm),
        TextWidget(
          subtitle,
          style: context.textStyles.labelLarge
              ?.copyWith(color: context.colors.onSecondary),
        ),
      ],
    );
  }
}
