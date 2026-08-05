part of '../snack_bar.dart';

class SnackBarBaseMessageWidget extends StatelessWidget {
  const SnackBarBaseMessageWidget({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    this.title,
    super.key,
  });

  final String? title;
  final String message;
  final Color backgroundColor;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return BlurWidget(
      sigmaX: 15,
      sigmaY: 15,
      borderRadius: BorderRadius.all(context.corners.rm),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(context.corners.rm),
          color: context.colors.onSecondary,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(context.insets.lg),
              child: Row(
                children: [
                  icon,
                  SizedBox(width: context.insets.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null)
                          TextWidget(
                            title,
                            style: context.textStyles.titleLarge
                                .copyWith(color: context.colors.primary),
                          ),
                        TextWidget(
                          message,
                          style: context.textStyles.titleSmall
                              .copyWith(color: context.colors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IndicatorLinearProgressWithTimerWidget(
              duration: 5,
              progressColor: backgroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
