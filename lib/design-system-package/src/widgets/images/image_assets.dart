part of 'images_widget.dart';

class ImageAssets extends StatelessWidget {
  const ImageAssets(
    this.path, {
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.color,
    this.border,
    this.fit = BoxFit.contain,
  });

  final String? path;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final Color? color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      return ImagePlaceholder(path, height: height, width: width);
    }
    return Skeleton.shade(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Image.asset(
            path!,
            fit: fit,
            height: height,
            width: width,
            errorBuilder: (context, url, error) => ImagePlaceholder(path),
          ),
        ),
      ),
    );
  }
}
