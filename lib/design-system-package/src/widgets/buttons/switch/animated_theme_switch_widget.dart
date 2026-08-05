part of 'switch.dart';

class AnimatedThemeSwitchWidget extends ConsumerWidget {
  const AnimatedThemeSwitchWidget({
    this.animationDuration = const Duration(milliseconds: 500),
    this.height = 50.0,
    this.borderWidth = 2.0,
    super.key,
  });

  final Duration animationDuration;
  final double height;
  final double borderWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeProvider);

    return themeAsync.when(
      data: (currentTheme) {
        return AnimatedToggleSwitch<AppThemeMode>.rolling(
          current: currentTheme,
          values: const [AppThemeMode.light, AppThemeMode.dark],
          onChanged: (theme) async {
            ref.read(themeProvider.notifier).mode = theme;
          },
          loading: false,
          animationDuration: animationDuration,
          height: height,
          borderWidth: borderWidth,
          iconBuilder: (AppThemeMode theme, bool value) {
            if (theme == AppThemeMode.dark) {
              return ImageSvgAsset(
                Assets.icons.moon.path,
                color: context.colors.primary,
                width: 20,
                height: 20,
              );
            } else {
              return ImageSvgAsset(
                Assets.icons.sunTheme.path,
                color: context.colors.onPrimary,
                width: 20,
                height: 20,
              );
            }
          },
          style: ToggleStyle(
            backgroundColor: context.colors.surface,
            borderColor: context.colors.primary.withOpacity(0.3),
            indicatorColor: context.colors.brandColor,
            borderRadius: BorderRadius.circular(30),
          ),
          iconOpacity: 0.7,
          spacing: 8,
        );
      },
      loading: () => SizedBox(
        width: 120,
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SizedBox(
        width: 120,
        height: height,
        child: const Center(child: Icon(Icons.error)),
      ),
    );
  }
}
