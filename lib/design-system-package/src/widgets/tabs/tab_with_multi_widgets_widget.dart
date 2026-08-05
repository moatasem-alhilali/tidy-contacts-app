part of 'tabs.dart';

class TabWithMultiWidgetsWidget extends StatelessWidget {
  const TabWithMultiWidgetsWidget({
    required this.titles,
    required this.widgets,
    required this.index,
    super.key,
  }) : assert(titles.length == widgets.length);

  final List<String> titles;
  final List<Widget> widgets;
  final ValueNotifier<int?> index;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: index,
      builder: (context, value, child) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(context.corners.rc360),
                color: context.colors.primary,
              ),
              child: Row(
                children: [
                  ...titles.map(
                    (title) => Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: context.insets.md,
                      ),
                      child: InkWell(
                        onTap: () {
                          index.value = titles.indexOf(title);
                        },
                        child: _TapWidget(
                          title: title,
                          isActive: titles.indexOf(title) == value,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spaces.xl),
            if (value != null) widgets[value],
          ],
        );
      },
    );
  }
}

class _TapWidget extends StatelessWidget {
  const _TapWidget({
    required this.isActive,
    required this.title,
  });

  final bool isActive;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(context.corners.rc360),
        border: Border.all(
          color: isActive ? context.colors.onPrimary : context.colors.tertiary,
        ),
        color: context.colors.tertiary,
      ),
      padding: EdgeInsets.symmetric(horizontal: context.insets.mn),
      alignment: Alignment.center,
      child: TextWidget(
        title,
        style: context.textStyles.labelLarge.copyWith(
          color: context.colors.onPrimary,
        ),
      ),
    );
  }
}
