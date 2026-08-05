part of 'images_widget.dart';

enum ImageType { asset, network, svgAsset, svgNetwork, file, unknown }

class ImageWidget extends StatelessWidget {
  const ImageWidget(
    this.path, {
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
    this.color,
    this.border,
    this.isCircle = false,
    this.fromPackage = false,
    super.key,
  });

  final String? path;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  final Color? color;
  final BoxBorder? border;
  final bool isCircle;
  final bool fromPackage;

  ImageType _determineImageType(String path) {
    final isSvg = path.endsWith('.svg');

    final isNetwork =
        Uri.tryParse(path)?.scheme == 'http' ||
        Uri.tryParse(path)?.scheme == 'https';
    final isAsset = !isNetwork;

    if (isSvg) {
      return isNetwork ? ImageType.svgNetwork : ImageType.svgAsset;
    }
    if (path.startsWith('/')) {
      return ImageType.file;
    }
    if (isAsset) {
      return ImageType.asset;
    }
    if (isNetwork) {
      return ImageType.network;
    }
    return ImageType.unknown;
  }

  @override
  Widget build(BuildContext context) {
    final imageType = _determineImageType(path ?? '');

    switch (imageType) {
      case ImageType.asset:
        return ImageAssets(
          path,
          width: width,
          height: height,
          borderRadius:
              borderRadius ??
              (isCircle ? BorderRadius.all(context.corners.rc360) : null),
          fit: fit,
          color: color,
          border: border,
        );
      case ImageType.network:
        return ImageNetworkWidget(
          path,
          width: width,
          height: height,
          color: color,
          borderRadius:
              borderRadius ??
              (isCircle ? BorderRadius.all(context.corners.rc360) : null),
          fit: fit,
          border: border,
        );
      case ImageType.svgAsset:
        return ImageSvgAsset(
          path!,
          width: width,
          height: height,
          borderRadius:
              borderRadius ??
              (isCircle ? BorderRadius.all(context.corners.rc360) : null),
          fit: fit,
          color: color,
          border: border,
          fromPackage: fromPackage,
        );
      case ImageType.svgNetwork:
        return ImageSvgNetwork(
          path!,
          width: width,
          height: height,
          borderRadius:
              borderRadius ??
              (isCircle ? BorderRadius.all(context.corners.rc360) : null),
          fit: fit,
          color: color,
          border: border,
        );
      case ImageType.file:
        return ImageFileWidget(
          path!,
          width: width,
          height: height,
          borderRadius:
              borderRadius ??
              (isCircle ? BorderRadius.all(context.corners.rc360) : null),
          fit: fit,
          color: color,
          border: border,
        );
      case ImageType.unknown:
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: context.colors.brandColor,
            borderRadius: borderRadius,
          ),
        );
    }
  }
}
