part of 'menus.dart';

class PopupMenuWidget extends StatefulWidget {
  const PopupMenuWidget({
    required this.items,
    required this.builder,
    this.onSelected,
    this.value,
    super.key,
  });

  final PopupMenuItemSelected<MenuItemEntry>? onSelected;
  final MenuItemEntry? value;
  final List<MenuItemEntry> items;
  final Widget Function(MenuItemEntry? value) builder;

  @override
  State<PopupMenuWidget> createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<PopupMenuWidget> {
  MenuItemEntry? value;

  @override
  void initState() {
    value = widget.value ?? widget.items.firstOrNull;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButtonX<MenuItemEntry>(
      onSelected: (value) {
        setState(() {
          this.value = value;
          widget.onSelected?.call(value);
        });
      },
      itemBuilder: (BuildContext context) {
        return widget.items
            .map(
              (MenuItemEntry item) => PopupMenuItemX<MenuItemEntry>(
                value: item,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null)
                      ImageSvgAsset(item.icon!, color: item.color),
                    SizedBox(width: context.insets.md),
                    Expanded(
                      child: TextWidget(
                        item.label,
                        style: context.textStyles.titleSmall.copyWith(
                          color:
                              item.color ?? context.colors.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList();
      },
      child: widget.builder(value),
    );
  }
}
