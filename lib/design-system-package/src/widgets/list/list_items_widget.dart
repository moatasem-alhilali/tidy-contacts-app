part of 'list_widgets.dart';
//TODO: remove unused
class ListItemsWidget<T> extends StatefulWidget {
  const ListItemsWidget({
    required this.entries,
    required this.entry,
    required this.onChanged,
    this.title,
    super.key,
  });

  final String? title;
  final List<ListItemEntry<T>> entries;
  final ListItemEntry<T> entry;
  final ValueChanged<ListItemEntry<T>> onChanged;

  @override
  State<ListItemsWidget<T>> createState() => _ListItemsWidgetState<T>();
}

class _ListItemsWidgetState<T> extends State<ListItemsWidget<T>> {
  ListItemEntry<T>? entry;

  @override
  void initState() {
    entry = widget.entry;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextColor(
      color: context.colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (true == widget.title?.isNotEmpty) ...[
              TextWidget(
                widget.title,
                style: context.textStyles.headlineMedium,
              ),
              SizedBox(height: context.spaces.xl),
            ],
            for (final entry in widget.entries) ...[
              ItemListWidget(
                title: entry.text,
                isSelected: this.entry == entry,
                onPressed: () =>
                    setState(() {
                      this.entry = entry;
                      widget.onChanged.call(entry);
                    }),
              ),
              SizedBox(height: context.insets.mn),
            ],
          ],
        ),
      ),
    );
  }
}

@immutable
class ListItemEntry<T> {
  const ListItemEntry({
    required this.text,
    this.id,
  });

  final T? id;
  final String text;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ListItemEntry && other.id == id && other.text == text;
  }

  /// The `hashCode` for `ListFieldModel`, used in hash-based collections.
  @override
  int get hashCode => Object.hash(id, text);
}
