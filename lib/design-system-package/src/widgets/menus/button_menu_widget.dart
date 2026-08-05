part of 'menus.dart';

class ButtonMenuWidget extends StatefulWidget {
  const ButtonMenuWidget({
    required this.items,
    this.value,
    this.labelText,
    this.onSelected,
    this.decoration,
    this.child,
    super.key,
  });

  final MenuEntry? value;
  final List<MenuEntry> items;
  final String? labelText;
  final PopupMenuItemSelected<MenuEntry>? onSelected;
  final Decoration? decoration;
  final Widget? child;

  @override
  State<ButtonMenuWidget> createState() => _ButtonMenuWidgetState();
}

class _ButtonMenuWidgetState extends State<ButtonMenuWidget> {
  MenuEntry? value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton<MenuEntry>(
        offset: const Offset(-20, -10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(context.corners.rc),
        ),
        onSelected: (value) => setState(() {
          this.value = value;
          widget.onSelected?.call(value);
        }),
        color: context.colors.primary,
        itemBuilder: (BuildContext context) => widget.items
            .map(
              (entry) => PopupMenuItem<MenuEntry>(
                value: entry,
                child: TextWidget(
                  entry.text,
                  style: context.textStyles.titleSmall.copyWith(
                    color: context.colors.onTertiaryContainer,
                  ),
                ),
              ),
            )
            .toList(),
        child:
            widget.child ??
            DecoratedBox(
              decoration: widget.decoration ?? const BoxDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                    widget.labelText,
                    style: context.textStyles.titleLarge.copyWith(
                      color: context.colors.onTertiaryContainer,
                    ),
                  ),
                  SizedBox(width: context.spaces.sm),
                  // Assets.icons.arrowRight
                  //     .svg(
                  //       color: context.colors.onTertiaryContainer,
                  //       width: 16.h,
                  //       height: 16.h,
                  //     )
                  //     .rotate(quarterTurns: 1),
                ],
              ),
            ),
      ),
    );
  }
}

@immutable
class MenuEntry {
  const MenuEntry({required this.id, required this.text});

  final int id;
  final String text;

  /// Operator `==` for comparing two `DropdownMenuModel` instances.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MenuEntry && other.id == id && other.text == text;
  }

  /// The `hashCode` for `ListFieldModel`, used in hash-based collections.
  @override
  int get hashCode => Object.hash(id, text);
}
