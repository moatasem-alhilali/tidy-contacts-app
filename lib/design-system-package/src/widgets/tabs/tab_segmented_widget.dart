part of 'tabs.dart';

class TabSegmentedWidget extends StatelessWidget {
  const TabSegmentedWidget({
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
    super.key,
  });

  final List<String> options;
  final String selectedOption;
  final void Function(String option, int index) onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: context.insets.sm,
        horizontal: context.insets.sm,
      ),
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        color: context.colors.secondary,
        borderRadius: BorderRadius.all(context.corners.rc360),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: context.insets.md,
          children: options.asMap().entries.map((option) {
            final isSelected = option.value == selectedOption;

            return GestureDetector(
              onTap: () => onOptionSelected(option.value, option.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  vertical: context.insets.md,
                  horizontal: context.insets.md,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? context.colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.all(context.corners.rc360),
                ),
                child: TextWidget(
                  option.value,
                  style: context.textStyles.labelMedium.copyWith(
                    color: isSelected
                        ? context.colors.onPrimary
                        : context.colors.onSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
