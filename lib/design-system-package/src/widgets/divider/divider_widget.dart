part of 'divider.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Calculate the number of dividers that can fit into the available width
        double dividerWidth = context
            .insets
            .sm; // The space between dividers (you can adjust this as needed)
        int dividerCount = ((constraints.maxWidth * 0.6) / (dividerWidth + 1))
            .floor(); // Adjusted to allow for the space between dividers
        return Row(
          children: [
            for (var i = 0; i < dividerCount; ++i) ...[
              Flexible(
                child: Divider(height: 1, color: context.colors.onSecondary),
              ),
              if (i != dividerCount - 1) SizedBox(width: context.insets.sm),
            ],
          ],
        );
      },
    );
  }
}
