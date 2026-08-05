part of 'helper_widgets.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({
    this.title,
    this.subtitle,
    this.buttonText,
    this.image,
    this.titleIcon,
    this.onPressed,
    this.padding,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final String? buttonText;
  final String? image;
  final String? titleIcon;
  final dynamic Function()? onPressed;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: SingleChildScrollView(
        padding: padding ?? EdgeInsets.symmetric(horizontal: context.insets.mn),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) ...[
              Image.asset(image!),
              SizedBox(height: context.spaces.xl),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: TextWidget(
                    title ?? 'حدث خطأ',
                    style: context.textStyles.headlineMedium.copyWith(
                      color: context.colors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (titleIcon != null) ...[
                  SizedBox(width: context.insets.md),
                  ImageSvgAsset(
                    titleIcon!,
                    color: context.colors.primary,
                    height: 24,
                    width: 24,
                  ),
                ],
              ],
            ),
            SizedBox(height: context.insets.xl),
            TextWidget(
              subtitle,
              style: context.textStyles.titleMedium.copyWith(
                color: context.colors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.spaces.xl),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 279),
              child: ButtonPrimaryWidget(
                text: buttonText ?? 'إعادة المحاولة',
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
