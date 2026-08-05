part of 'list_widgets.dart';

class ItemListWidget extends StatelessWidget {
  const ItemListWidget({
    this.title,
    this.onPressed,
    this.isSelected,
    super.key,
    this.titleStyle,
  });

  final String? title;
  final bool? isSelected;
  final VoidCallback? onPressed;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59.h,
      child: BlurWidget(
        sigmaY: true == isSelected ? 20 : 0,
        sigmaX: true == isSelected ? 20 : 0,
        borderRadius: BorderRadius.all(context.corners.rc360),
        child: MaterialButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(context.corners.rc360),
            side: BorderSide(
              color: true == isSelected
                  ? context.colors.white
                  : Colors.transparent,
              width: 1.5.h,
            ),
          ),
          color: true == isSelected
              ? context.colors.background$10
              : context.colors.background$30,
          padding: EdgeInsets.symmetric(horizontal: context.insets.mn),
          elevation: 0,
          highlightElevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageSvgAsset(
                ' Assets.icons.check.path',
                color: true == isSelected
                    ? context.colors.white
                    : Colors.transparent,
                width: 24.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.insets.sm),
                child: TextWidget(
                  title,
                  style:
                      titleStyle ??
                      context.textStyles.titleMedium.copyWith(
                        color: context.colors.white,
                      ),
                ),
              ),
              SizedBox(width: context.insets.mn),
            ],
          ),
        ),
      ),
    );
  }
}
