part of '../cards.dart';

class ListTileCollapseWidget extends StatelessWidget {
  const ListTileCollapseWidget({
    required this.title,
    this.content,
    this.titleStyle,
    this.contentStyle,
    this.color,
    super.key,
  });

  final String title;
  final String? content;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ExpandTileBaseWidget(
      iconBegin: 'Assets.icons.add.path',
      iconEnd: 'Assets.icons.minus.path',
      borderSide: BorderSide.none,
      color: color,
      padding: EdgeInsets.all(context.insets.xl),
      title: TextWidget(
        title,
        style:
            titleStyle ??
            context.textStyles.titleSmall.copyWith(
              color: context.colors.onPrimaryContainer,
            ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: context.insets.md),
        child: TextWidget(
          content,
          style:
              contentStyle ??
              context.textStyles.labelLarge.copyWith(
                color: color ?? context.colors.onSecondary,
              ),
        ),
      ),
    );
  }
}
