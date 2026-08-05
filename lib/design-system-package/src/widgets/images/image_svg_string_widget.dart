part of 'images_widget.dart';

class ImageSvgStringWidget extends StatelessWidget {
  const ImageSvgStringWidget(
    this.assetString, {
    this.height,
    this.width,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.fit,
    this.border,
    this.fromPackage = false,
    super.key,
  });

  final String assetString;
  final double? height;
  final double? width;
  final Color? color;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final BoxBorder? border;
  final bool fromPackage;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      assetString,
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      colorFilter:
          color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
