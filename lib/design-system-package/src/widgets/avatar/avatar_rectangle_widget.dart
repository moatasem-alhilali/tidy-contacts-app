part of 'avatar.dart';

class AvatarRectangleWidget extends StatelessWidget {
  const AvatarRectangleWidget({
    required this.image,
    this.text,
    super.key,
    this.size,
  });

  final Widget? image;
  final String? text;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(context.corners.rc),
          child: image,
        ),
        if (text != null)
          SizedBox(
            height: context.insets.sm,
          ),
        if (text != null)
          TextWidget(
            text,
            style: context.textStyles.titleLarge?.copyWith(
              color: context.colors.onPrimary,
            ),
          ),
      ],
    );
  }
}
