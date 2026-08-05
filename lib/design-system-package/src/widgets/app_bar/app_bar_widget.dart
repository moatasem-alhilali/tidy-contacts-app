part of 'app_bar.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    required this.title,
    this.onBack,
    this.isCenterTitle = true,
    this.elevation = 0.0,
    this.leading,
    this.trailing,
    super.key,
  });

  final String title;
  final VoidCallback? onBack;
  final bool isCenterTitle;
  final double elevation;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: elevation != 0 ? context.colors.onSurface : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leading != null) leading!,
          if (leading == null)
          IconButton(
            onPressed:
                onBack ??
                () {
                  // context.popV2();
                },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          if (isCenterTitle) Text(title),
          if (trailing != null) trailing!,
          const SizedBox(),
        ],
      ),
    );
  }
}
