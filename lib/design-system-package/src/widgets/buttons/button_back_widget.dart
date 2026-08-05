part of 'buttons.dart';

class ButtonBackWidget extends StatelessWidget {
  const ButtonBackWidget({super.key, this.onTap, this.title, this.color});

  final void Function()? onTap;
  final String? title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // splashColor: Colors.transparent,
      // hoverColor: Colors.transparent,
      // focusColor: Colors.transparent,
      // highlightColor: Colors.transparent,
      onPressed: () => Navigator.of(context).pop(),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, color: color ?? context.colors.surface),
          context.insets.md.horizontalSpace,
          if (title != null)
            TextWidget(
              title,
              style: context.textStyles.titleMedium.copyWith(
                color: context.colors.surface,
              ),
            ),
        ],
      ),
    );
  }
}
