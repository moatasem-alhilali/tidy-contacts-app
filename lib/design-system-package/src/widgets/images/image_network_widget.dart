part of 'images_widget.dart';

class ImageNetworkWidget extends StatelessWidget {
  const ImageNetworkWidget(
    this.url, {
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.color,
    this.border,
    this.fit = BoxFit.contain,
  });

  final String? url;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
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
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: url == null
              ? Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 70.h,
                      maxWidth: 70.h,
                    ),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.colors.onSecondary,
                        borderRadius: borderRadius,
                      ),
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: url!,
                  fit: fit,
                  height: height,
                  width: width,
                  errorWidget: (context, url, error) => Center(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 70.h,
                          maxWidth: 70.h,
                        ),
                        child: Container(
                          // height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.colors.onSecondary,
                            borderRadius: borderRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                  placeholder: (context, url) => ShimmerWidget(
                    child: Container(
                      // height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.colors.onSecondary,
                        borderRadius: borderRadius,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
