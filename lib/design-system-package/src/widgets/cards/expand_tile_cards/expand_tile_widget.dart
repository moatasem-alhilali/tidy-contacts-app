part of '../cards.dart';

class ExpandTileWidget extends StatelessWidget {
  const ExpandTileWidget({
    this.leading,
    this.title,
    this.body,
    this.iconBeginTurn,
    this.iconEndTurn,
    this.borderSide,
    this.padding,
    super.key,
  });

  final String? leading;
  final String? title;
  final Widget? body;
  final double? iconBeginTurn;
  final double? iconEndTurn;
  final BorderSide? borderSide;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return ExpandTileBaseWidget(
      iconBeginTurn: iconBeginTurn,
      iconEndTurn: iconEndTurn,
      borderSide: borderSide,
      padding: padding,
      leading: TextWidget(
        leading,
        style: context.textStyles.titleSmall
            .copyWith(color: context.colors.onPrimaryContainer),
        maxLines: 1,
      ),
      title: true == title?.isNotEmpty
          ? TextWidget(
              title,
              style: context.textStyles.headlineXSmall.copyWith(
                color: context.colors.onPrimaryContainer,
              ),

              textAlign: TextAlign.end,
              maxLines: 1,
            )
          : null,
      body: Padding(
        padding: EdgeInsets.only(top: context.insets.md),
        child: body,
      ),
    );
  }
}
