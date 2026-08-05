part of 'app_bar.dart';

class AppBarCardWidget extends StatelessWidget {
  const AppBarCardWidget({
    this.title,
    this.showCircleWidget = true,
    this.backgroundImage,
    this.backgroundColor,
    this.typeIcon,
    this.typeText,
    this.iconFromPackage = false,
    this.backgroundImageFromPackage = false,
    this.height,
    this.content,
    super.key,
  });

  final String? backgroundImage;
  final Color? backgroundColor;
  final String? title;
  final Widget? content;
  final String? typeIcon;
  final String? typeText;
  final bool showCircleWidget;
  final bool iconFromPackage;
  final bool backgroundImageFromPackage;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 104.h,
      decoration: BoxDecoration(
        color: backgroundImage != null
            ? null
            : (backgroundColor ?? context.colors.onPrimary),
        borderRadius: BorderRadius.all(context.corners.rb),
      ),
      child: Stack(
        children: [
          if(backgroundImage != null)
          ContainerShadeWidget(
            backChild: ImageWidget(
              backgroundImage,
              height: height ?? 104.h,
              width: double.infinity,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.all(context.corners.rb),
              fromPackage: backgroundImageFromPackage,
            ),
          ),
          Center(
            child: content ??
                TextWidget(
                  title,
                  style: context.textStyles.headlineSmall.copyWith(
                    color: context.colors.white,
                  ),
                ),
          ),
          if (showCircleWidget)
            PositionedDirectional(
              end: context.insets.xl,
              top: context.spaces.sm,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: context.colors.background$30,
                child: Center(
                  child: typeIcon == null
                      ? TextWidget(
                          typeText,
                          style: context.textStyles.headlineSmall.copyWith(
                            color: context.colors.white,
                          ),
                        )
                      : ImageSvgAsset(
                          typeIcon!,
                          color: context.colors.white,
                          fromPackage: iconFromPackage,
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
