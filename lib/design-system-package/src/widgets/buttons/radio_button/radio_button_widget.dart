part of 'radio_button.dart';

class CustomRadioGroup extends StatefulWidget {
  final List<String> options;
  final Function(int) onChanged;
  final int? selectedValue;

  const CustomRadioGroup({
    Key? key,
    required this.options,
    required this.onChanged,
    this.selectedValue,
  }) : super(key: key);

  @override
  _CustomRadioGroupState createState() => _CustomRadioGroupState();
}

class _CustomRadioGroupState extends State<CustomRadioGroup> {
  int _selectedValue = -1;

  @override
  void initState() {
    if (widget.selectedValue != null) {
      setState(() {
        _selectedValue = widget.selectedValue!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.insets.xl,
      children: widget.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        return InkWell(
          onTap: () {
            setState(() {
              _selectedValue = index;
              widget.onChanged(index);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                option,
                style: context.textStyles.titleSmall
                    .copyWith(color: context.colors.onPrimary),
              ),
              CupertinoRadio<int>(
                value: index,
                groupValue: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                    widget.onChanged(value);
                  });
                },
                activeColor: context.colors.onPrimary,
                fillColor: context.colors.secondary,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
