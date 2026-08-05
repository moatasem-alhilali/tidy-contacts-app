part of 'menus.dart';

class DropdownMenuWidget extends StatefulWidget {
  const DropdownMenuWidget({
    required this.options,
    required this.onChanged,
    this.hintText,
    this.width,
    super.key,
  });

  final List<MenuItemEntry> options;
  final String? hintText;
  final ValueChanged<MenuItemEntry?> onChanged;
  final double? width;

  @override
  State<DropdownMenuWidget> createState() => _DropdownMenuWidgetState();
}

class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
  final TextEditingController menuController = TextEditingController();
  MenuItemEntry? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<MenuItemEntry>(
      width: widget.width,
      controller: menuController,
      hintText: widget.hintText ?? LocaleKeys.select.tr(),
      requestFocusOnTap: false,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(context.corners.rs),
        ),
      ),
      textStyle: context.textStyles.labelLarge.copyWith(
        color: context.colors.onPrimaryContainer,
      ),
      trailingIcon: const Icon(Icons.keyboard_arrow_down),
      selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          context.colors.tertiaryContainer,
        ),
        shape: WidgetStatePropertyAll(
          ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(context.corners.rs),
          ),
        ),
      ),
      onSelected: (MenuItemEntry? menu) {
        setState(() {
          selectedMenu = menu;
        });
        widget.onChanged(menu);
      },
      dropdownMenuEntries: widget.options.map<DropdownMenuEntry<MenuItemEntry>>(
        (MenuItemEntry menu) {
          return DropdownMenuEntry<MenuItemEntry>(
            value: menu,
            label: menu.label,
            labelWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (menu.icon != null) ...[
                  ImageSvgAsset(menu.icon!, color: menu.color),
                  SizedBox(width: context.insets.sm),
                ],
                TextWidget(
                  menu.label,
                  style: context.textStyles.labelMedium.copyWith(
                    color: context.colors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            leadingIcon: selectedMenu == menu
                ? Container(
                    height: 40.h,
                    width: 2.h,
                    color: context.colors.onPrimaryContainer,
                  )
                : SizedBox(width: 2.h),
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(
                EdgeInsetsDirectional.only(start: 2, end: 1),
              ),
              backgroundColor: WidgetStatePropertyAll(
                context.colors.primaryContainer,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

@immutable
class MenuItemEntry {
  const MenuItemEntry({
    required this.id,
    required this.label,
    this.icon,
    this.color,
  });

  final int id;
  final String label;
  final String? icon;
  final Color? color;

  /// Operator `==` for comparing two `DropdownMenuModel` instances.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MenuItemEntry &&
        other.id == id &&
        other.label == label &&
        other.icon == icon &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(id, label, icon, color);
}
