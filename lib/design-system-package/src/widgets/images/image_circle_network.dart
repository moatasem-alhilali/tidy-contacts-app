part of 'images_widget.dart';

class ImageCircleNetwork extends StatelessWidget {
  const ImageCircleNetwork(this.url, {
    this.size,
    this.color,
    this.border,
    this.fit = BoxFit.contain,
    super.key,
  });

  final String? url;
  final double? size;
  final BoxFit? fit;
  final Color? color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return ImageNetworkWidget(
      url,
      borderRadius: BorderRadius.all(context.corners.rc360),
      width: size,
      height: size,
      color: color,
      fit: fit,
      border: border,
    );
  }
}
