part of 'images_widget.dart';

class ImageWithColorWidget extends StatelessWidget {
  const ImageWithColorWidget({
    required this.color,
    required this.icon,
    required this.defaultIcon,
    super.key,
  });

  final String? color;
  final String? icon;
  final String? defaultIcon;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          height: 40.h,
          width: 40.h,
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color:
                color == null ? context.colors.secondary : Color(color.toInt),
          ),
          alignment: Alignment.center,
          child: color != null
              ? null
              : ImageWidget(
                  icon ?? defaultIcon,
                  width: icon != null ? 40.h : 22.h,
                  height: icon != null ? 40.h : 22.h,
                  color: context.colors.onPrimary,
                  borderRadius: BorderRadius.all(context.corners.rc360),
                  fit: icon != null ? BoxFit.cover : BoxFit.contain,
                  fromPackage: true,
                ),
        );
      },
    );
  }
}
