part of 'images_widget.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder(
    this.path, {
    super.key,
    this.height,
    this.width,
    this.color,
    this.border,
    this.fit = BoxFit.contain,
  });

  final String? path;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Skeleton.shade(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: BorderRadius.all(context.corners.rb),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height ?? 70.h,
              maxWidth: width ?? 70.h,
            ),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colors.brandColor,
                borderRadius: BorderRadius.all(context.corners.rb),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
