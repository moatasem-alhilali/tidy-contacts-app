part of 'images_widget.dart';

class ImageSvgNetwork extends StatelessWidget {
  const ImageSvgNetwork(
    this.assetName, {
    this.height,
    this.width,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.fit,
    this.border,
    super.key,
  });

  final String assetName;
  final double? height;
  final double? width;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: SvgPicture.network(
          assetName,
          height: height,
          width: width,
          colorFilter: color == null
              ? null
              : ColorFilter.mode(color!, BlendMode.srcIn),
          errorBuilder: (context, error, stackTrace) => ImageSvgAsset(
            'Assets.icons.placeholderImage.path,',
            height: height,
            width: width,
            color: color,
            fromPackage: true,
          ),
          placeholderBuilder: (context) => ShimmerSkeletonizerWidget(
            child: ImageSvgAsset(
              'Assets.icons.placeholderImage.path,',
              height: height,
              width: width,
              color: color,
              fromPackage: true,
            ),
          ),
        ),
      ),
    );
  }
}
