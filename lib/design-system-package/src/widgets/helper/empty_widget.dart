part of 'helper_widgets.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
     this.title,
    this.subTitle,
    this.path,
    this.padding,
    this.fromPackage = false,
    this.buttonText,
    this.onButtonPressed,
    super.key,
  });

  final String? path;
  final String ?title;
  final String? subTitle;
  final EdgeInsets? padding;
  final bool fromPackage;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: const EdgeInsets.all(8.0),

      width: double.infinity,
      child: SingleChildScrollView(
        padding: padding ?? EdgeInsets.symmetric(horizontal: context.insets.mn),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (path != null) ImageAssets(path, height: 118.h, width: 118.h),
            SizedBox(height: context.insets.mn),
            TextWidget(
              title??'لا يوجد بيانات',
              style: context.textStyles.headlineSmall.copyWith(
                color: context.colors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.insets.xl),
            TextWidget(
              subTitle,
              style: context.textStyles.titleMedium.copyWith(
                color: context.colors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              SizedBox(height: context.insets.xl),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 279),
                child: ButtonPrimaryWidget(
                  text: buttonText!,
                  onPressed: onButtonPressed!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
