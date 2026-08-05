part of 'switch.dart';

class SwitchThemeWidget extends StatefulWidget {
  const SwitchThemeWidget({
    required this.initialTheme,
    required this.onThemeChanged,
    this.backColor,
    this.animationDuration = const Duration(milliseconds: 300),
    super.key,
  });

  final AppThemeMode initialTheme;
  final void Function(AppThemeMode) onThemeChanged;
  final Color? backColor;
  final Duration animationDuration;

  @override
  State<SwitchThemeWidget> createState() => _SwitchThemeWidgetState();
}

class _SwitchThemeWidgetState extends State<SwitchThemeWidget>
    with TickerProviderStateMixin {
  late AppThemeMode currentTheme;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  IconData get _currentIcon => currentTheme == AppThemeMode.dark
      ? Icons.nightlight_round
      : Icons.wb_sunny;

  @override
  void initState() {
    super.initState();
    currentTheme = widget.initialTheme;

    // Rotation animation controller
    _rotationController = AnimationController(
      duration: Duration(
        milliseconds: (widget.animationDuration.inMilliseconds * 0.8).round(),
      ),
      vsync: this,
    );

    // Scale animation controller
    _scaleController = AnimationController(
      duration: Duration(
        milliseconds: (widget.animationDuration.inMilliseconds * 0.4).round(),
      ),
      vsync: this,
    );

    // Fade animation controller
    _fadeController = AnimationController(
      duration: Duration(
        milliseconds: (widget.animationDuration.inMilliseconds * 0.3).round(),
      ),
      vsync: this,
    );

    // Rotation animation with bounce effect
    _rotationAnimation = Tween<double>(begin: 0, end: 1.5 * pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.elasticOut),
    );

    // Scale animation with bounce
    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Fade animation for smooth transition
    _fadeAnimation = Tween<double>(begin: 1, end: 0.3).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  void _toggleTheme() {
    final newTheme = currentTheme == AppThemeMode.dark
        ? AppThemeMode.light
        : AppThemeMode.dark;

    // Stop all animations first
    _fadeController.stop();
    _scaleController.stop();
    _rotationController.stop();

    // Start fade out animation
    _fadeController.forward().then((_) {
      // Change theme and update state
      widget.onThemeChanged(newTheme);
      setState(() => currentTheme = newTheme);

      // Reset and start animations in sequence
      _fadeController.reset();
      _scaleController.reset();
      _rotationController.reset();

      // Start fade in
      _fadeController.forward();

      // Start scale animation with slight delay
      Future.delayed(Duration(milliseconds: 100), () {
        _scaleController.forward();
      });

      // Start rotation animation with slight delay
      Future.delayed(Duration(milliseconds: 150), () {
        _rotationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.animationDuration,
      padding: EdgeInsets.symmetric(
        horizontal: context.insets.md,
        vertical: context.insets.sm,
      ),
      decoration: BoxDecoration(
        // color: widget.backColor ?? context.colors.tertiary,
        borderRadius: BorderRadius.all(context.corners.rc360),
      ),
      child: GestureDetector(
        onTap: _toggleTheme,
        child: AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return AnimatedBuilder(
              animation: _scaleController,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: AnimatedOpacity(
                          opacity: _fadeAnimation.value,
                          duration: Duration(milliseconds: 150),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: context.colors.onPrimary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: context.colors.primary.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                _currentIcon,
                                color: context.colors.primary,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
