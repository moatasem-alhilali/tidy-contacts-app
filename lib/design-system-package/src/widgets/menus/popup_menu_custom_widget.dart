part of 'menus.dart';

class PopupMenuCustomWidget extends StatefulWidget {
  const PopupMenuCustomWidget({
    required this.items,
    required this.builder,
    this.onSelected,
    this.showCheck,
    this.value,
    this.radius,
    this.position,
    super.key,
  });

  final PopupMenuItemSelected<MenuItemEntry>? onSelected;
  final MenuItemEntry? value;
  final List<MenuItemEntry> items;
  final Widget Function(MenuItemEntry? value) builder;
  final bool? showCheck;
  final Radius? radius;
  final PopupMenuPosition? position;

  @override
  State<PopupMenuCustomWidget> createState() => _PopupMenuCustomWidgetState();
}

class _PopupMenuCustomWidgetState extends State<PopupMenuCustomWidget> {
  MenuItemEntry? value;

  @override
  void initState() {
    value = widget.value ?? widget.items.firstOrNull;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItemEntry>(
      borderRadius: BorderRadius.all(widget.radius ?? context.corners.rb),
      onSelected: (value) {
        setState(() {
          this.value = value;
          widget.onSelected?.call(value);
        });
      },
      position: widget.position,
      itemBuilder: (BuildContext context) {
        return widget.items
            .map(
              (MenuItemEntry item) => PopupMenuItem<MenuItemEntry>(
                value: item,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null)
                      ImageSvgAsset(
                        item.icon!,
                        color: item.color,
                      ),
                    SizedBox(width: context.insets.xl),
                    Expanded(
                      child: Text(
                        item.label,
                        style: context.textStyles.titleSmall.copyWith(
                          color:
                              item.color ?? context.colors.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    if (value == item && (widget.showCheck ?? false))
                      Icon(
                        Icons.check,
                        color: context.colors.primary,
                      ),
                  ],
                ),
              ),
            )
            .toList();
      },
      color: context.colors.primary,
      child: widget.builder(value),
    );
  }
}
