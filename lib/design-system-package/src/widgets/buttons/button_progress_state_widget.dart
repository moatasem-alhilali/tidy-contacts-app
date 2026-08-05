part of 'buttons.dart';

/// A highly interactive and performant progress button with advanced animations.
///
/// This button provides rich visual feedback including:
/// - Press down animations with scale and elevation effects
/// - Ripple effects on tap
/// - State-specific animations (loading pulse, success expand, error shake)
/// - Haptic feedback and optional sound feedback
/// - Long press and double tap gesture support
/// - Performance optimizations for smooth interactions
class ButtonProgressStateWidget extends StatefulWidget {
  const ButtonProgressStateWidget({
    super.key,
    this.state = RequestState.initial,
    this.text = 'اضافه',
    this.onPressed,
    this.onLongPress,
    this.onDoubleTap,
    this.border,
    this.width,
    this.height,
    this.borderRadius,
    this.defaultColor,
    this.marginVertical,
    this.colorText,
    this.icon,
    this.textLoading,
    this.textSuccess,
    this.isBorderColor = false,
    this.widthStateChange = true,
    this.iconAliment = Alignment.centerRight,
    this.shouldDisplayIconLoading = true,
    this.animationDuration = const Duration(milliseconds: 100),
    this.customWidget,
    this.enableHapticFeedback = true,
    this.enableSoundFeedback = false,
    this.enableRippleEffect = true,
    this.enablePressAnimation = true,
    this.pressDownScale = 0.95,
    this.elevationPressed = 8.0,
    this.elevationReleased = 2.0,
  });

  /// Animation duration for state changes
  final Duration animationDuration;

  /// should display icon in loading
  final bool shouldDisplayIconLoading;

  /// The text to display when the button is in the loading state.
  final String? textLoading;

  /// The text to display when the button is in the success state.
  final String? textSuccess;

  /// Whether the button's width should change based on its state.
  final bool? widthStateChange;

  /// An optional icon to display alongside the button text.
  final Widget? icon;

  /// The current state of the button.
  final RequestState state;

  /// The text to display when the button is in the default state.
  final String? text;

  final Widget? customWidget;

  /// The width of the button.
  final double? width;

  /// The height of the button.
  final double? height;

  /// The border radius of the button.
  final double? borderRadius;

  /// The default background color of the button.
  final Color? defaultColor;

  /// The color of the button text.
  final Color? colorText;

  /// The border of the button.
  final Border? border;

  /// The vertical margin around the button.
  final double? marginVertical;

  /// The callback function to execute when the button is pressed.
  final void Function()? onPressed;

  /// The callback function to execute when the button is long pressed.
  final void Function()? onLongPress;

  /// The callback function to execute when the button is double tapped.
  final void Function()? onDoubleTap;

  /// Whether the button should use a border color instead of a background color.
  final bool isBorderColor;

  final Alignment iconAliment;

  /// Whether to enable haptic feedback on interactions.
  final bool enableHapticFeedback;

  /// Whether to enable sound feedback on interactions.
  final bool enableSoundFeedback;

  /// Whether to enable ripple effect on tap.
  final bool enableRippleEffect;

  /// Whether to enable press down animation.
  final bool enablePressAnimation;

  /// Scale factor when button is pressed down (0.0 to 1.0).
  final double pressDownScale;

  /// Elevation when button is pressed.
  final double elevationPressed;

  /// Elevation when button is released.
  final double elevationReleased;

  @override
  State<ButtonProgressStateWidget> createState() =>
      _ButtonProgressStateWidgetState();
}

class _ButtonProgressStateWidgetState extends State<ButtonProgressStateWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _elevationController;
  late AnimationController _rippleController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _successController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _rippleAnimation;
  Offset? _tapPosition;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _successAnimation;

  bool _isPressed = false; // Used to track press state for visual feedback

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Scale animation for press feedback
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: widget.pressDownScale)
        .animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
        );

    // Elevation animation
    _elevationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation =
        Tween<double>(
          begin: widget.elevationReleased,
          end: widget.elevationPressed,
        ).animate(
          CurvedAnimation(
            parent: _elevationController,
            curve: Curves.easeOutQuad,
          ),
        );

    // Glass/water-like ripple effect animation
    _rippleController = AnimationController(
      duration: const Duration(
        milliseconds: 1800,
      ), // Longer duration for realistic water/glass effect
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: const Cubic(0.25, 0.46, 0.45, 0.94), // Custom water-like curve
      ),
    );

    // Pulse animation for loading state
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Shake animation for error state
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    // Success expand animation
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _successAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    _startStateAnimations();
  }

  void _startStateAnimations() {
    switch (widget.state) {
      case RequestState.loading:
        // Removed annoying pulse animation - loading state is now static
        break;
      case RequestState.success:
        _successController.forward();
      case RequestState.error:
        _shakeController.forward();
      case RequestState.initial:
        _stopAllStateAnimations();
    }
  }

  void _stopAllStateAnimations() {
    _pulseController.stop();
    _successController.reset();
    _shakeController.reset();
  }

  @override
  void didUpdateWidget(ButtonProgressStateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _stopAllStateAnimations();
      _startStateAnimations();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _elevationController.dispose();
    _rippleController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_canInteract()) return;

    setState(() {
      _isPressed = true;
      _tapPosition = details.localPosition; // Store tap position for ripple
    });

    if (widget.enablePressAnimation) {
      _scaleController.forward();
      _elevationController.forward();
    }

    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _handleRelease();
  }

  void _handleTapCancel() {
    _handleRelease();
  }

  void _handleRelease() {
    setState(() {
      _isPressed = false;
    });

    if (widget.enablePressAnimation) {
      _scaleController.reverse();
      _elevationController.reverse();
    }
  }

  void _handleTap() {
    if (!_canInteract()) return;

    if (widget.enableRippleEffect) {
      // Trigger glass/water ripple effect immediately for natural feel
      _rippleController.forward().then((_) {
        // Allow effect to complete naturally before reset
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            _rippleController.reset();
          }
        });
      });
    }

    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    // Immediate callback for responsiveness (visual feedback is separate)
    widget.onPressed?.call();
  }

  void _handleLongPress() {
    if (!_canInteract()) return;

    if (widget.enableHapticFeedback) {
      HapticFeedback.heavyImpact();
    }

    widget.onLongPress?.call();
  }

  void _handleDoubleTap() {
    if (!_canInteract()) return;

    if (widget.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }

    widget.onDoubleTap?.call();
  }

  bool _canInteract() {
    return widget.state == RequestState.initial ||
        widget.state == RequestState.error;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      onLongPress: widget.onLongPress != null ? _handleLongPress : null,
      onDoubleTap: widget.onDoubleTap != null ? _handleDoubleTap : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _scaleAnimation,
          _elevationAnimation,
          _rippleAnimation,
          _pulseAnimation,
          _shakeAnimation,
          _successAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value * _getStateScale(),
            child: Transform.translate(
              offset: _getShakeOffset(),
              child: Container(
                width: widget.width,
                margin: EdgeInsets.symmetric(
                  vertical: widget.marginVertical ?? context.insets.md,
                ),
                height: widget.height ?? 45.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: widget.isBorderColor
                      ? widget.border ??
                            Border.all(color: context.colors.onPrimary)
                      : null,
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 8.r,
                  ),
                  color: widget.isBorderColor
                      ? null
                      : _getBackgroundColor(
                          widget.state,
                          widget.defaultColor,
                          context,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          _getBackgroundColor(
                            widget.state,
                            widget.defaultColor,
                            context,
                          )?.withValues(alpha: 0.3) ??
                          Colors.transparent,
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 8.r,
                  ),
                  child: Stack(
                    children: [
                      // Main content
                      Center(
                        child: AnimatedSwitcher(
                          duration: widget.animationDuration,
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                );
                              },
                          child: _getWidget(
                            widget.state,
                            widget.text,
                            context,
                            widget.colorText,
                            icon: widget.icon,
                            customWidget: widget.customWidget,
                          ),
                        ),
                      ),
                      // Ripple effect overlay - covers full container
                      if (widget.enableRippleEffect &&
                          _rippleAnimation.value > 0.0)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _RipplePainter(
                              animation: _rippleAnimation,
                              color: context.colors.primary.withValues(
                                alpha: 0.2,
                              ),
                              tapPosition: _tapPosition,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double _getStateScale() {
    switch (widget.state) {
      case RequestState.loading:
        return 1; // No scaling during loading - keep it stable
      case RequestState.success:
        return 1.0 + (_successAnimation.value * 0.1);
      case RequestState.error:
      case RequestState.initial:
        return 1;
    }
  }

  Offset _getShakeOffset() {
    if (widget.state == RequestState.error && _shakeAnimation.value > 0.0) {
      return Offset(
        (math.sin(_shakeAnimation.value * math.pi * 8) * 3.0).clamp(-3.0, 3.0),
        0,
      );
    }
    return Offset.zero;
  }

  /// Returns the background color of the button based on its state.
  Color? _getBackgroundColor(
    RequestState state,
    Color? defaultColor,
    BuildContext context,
  ) {
    switch (state) {
      case RequestState.initial:
        return defaultColor ?? context.colors.brandColor;
      case RequestState.loading:
        return context.colors.brandColor;
      case RequestState.success:
        return Colors.green;
      case RequestState.error:
        return context.colors.error;
    }
  }

  /// Returns the widget to display inside the button based on its state.
  Widget _getWidget(
    RequestState state,
    String? text,
    BuildContext context,
    Color? colorText, {
    Widget? icon,
    Widget? customWidget,
  }) {
    switch (state) {
      case RequestState.initial:
        return customWidget ??
            Row(
              key: const ValueKey('default'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.iconAliment == Alignment.centerRight) ...[
                  if (icon != null) icon,
                  if (icon != null) SizedBox(width: context.spaces.sm),
                ],
                Text(
                  text ?? 'Add',
                  style: context.textStyles.labelMedium.copyWith(
                    color: colorText ?? context.colors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.iconAliment == Alignment.centerLeft) ...[
                  if (icon != null) SizedBox(width: context.spaces.sm),
                  if (icon != null) icon,
                ],
              ],
            );
      case RequestState.loading:
        return Row(
          key: const ValueKey('loading'),
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: widget.textLoading != null,
              child: Padding(
                padding: EdgeInsets.only(right: context.spaces.sm),
                child: Text(
                  widget.textLoading ?? '',
                  style: context.textStyles.labelMedium.copyWith(
                    color: colorText ?? context.colors.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: context.spaces.sm),
            if (widget.shouldDisplayIconLoading)
              SizedBox(
                width: context.spaces.lg,
                height: context.spaces.lg,
                child: _LoadingIndicator(
                  color: colorText ?? context.colors.onPrimary,
                  backgroundColor: context.colors.primary.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
          ],
        );
      case RequestState.success:
        return Row(
          key: const ValueKey('success'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: widget.textSuccess != null,
              child: Padding(
                padding: EdgeInsets.only(right: context.spaces.sm),
                child: Text(
                  widget.textSuccess ?? '',
                  style: context.textStyles.labelMedium.copyWith(
                    color: colorText ?? context.colors.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _successAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _successAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background circle that expands
                      Container(
                        width: context.spaces.xl * _successAnimation.value,
                        height: context.spaces.xl * _successAnimation.value,
                        decoration: BoxDecoration(
                          color: (colorText ?? context.colors.onPrimary)
                              .withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Checkmark icon
                      Icon(
                        Icons.check,
                        color: colorText ?? context.colors.onPrimary,
                        size: context.spaces.lg,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      case RequestState.error:
        return Icon(
          Icons.error,
          color: colorText ?? context.colors.onPrimary,
          size: context.spaces.lg,
          key: const ValueKey('error'),
        );
    }
  }
}

/// Custom animated loading indicator with rotation and pulsing effects
class _LoadingIndicator extends StatefulWidget {
  const _LoadingIndicator({required this.color, required this.backgroundColor});
  final Color color;
  final Color backgroundColor;

  @override
  State<_LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _rotationController.repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: CustomPaint(
            size: const Size(24, 24),
            painter: _LoadingPainter(
              color: widget.color,
              backgroundColor: widget.backgroundColor,
            ),
          ),
        );
      },
    );
  }
}

/// Custom painter for the loading indicator
class _LoadingPainter extends CustomPainter {
  _LoadingPainter({required this.color, required this.backgroundColor});
  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 1.5, backgroundPaint);

    // Foreground arc
    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    const sweepAngle = math.pi * 1.5; // 270 degrees
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 1.5),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LoadingPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

/// Custom painter for creating glass/water ripple effect
class _RipplePainter extends CustomPainter {
  _RipplePainter({
    required this.animation,
    required this.color,
    this.tapPosition,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color color;
  final Offset? tapPosition;

  // Cache paint objects for better performance
  static final Map<int, Paint> _paintCache = {};
  static final Map<int, Paint> _shimmerPaintCache = {};

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;
    if (progress <= 0.0) return; // Early exit for performance

    // Use tap position if available, otherwise center
    final rippleCenter = tapPosition ?? Offset(size.width / 2, size.height / 2);

    // Calculate maximum radius needed to cover entire button from tap position
    final corners = [
      const Offset(0, 0),
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];

    final maxRadius =
        corners
            .map((corner) => (corner - rippleCenter).distance)
            .reduce(math.max) *
        1.2;

    // Glass/Water effect with multiple phases
    _drawGlassWaterEffect(canvas, rippleCenter, maxRadius, progress);
  }

  void _drawGlassWaterEffect(
    Canvas canvas,
    Offset center,
    double maxRadius,
    double progress,
  ) {
    // Phase 1: Entry wave (0.0 - 0.4) - Fast initial expansion like water drop
    // Phase 2: Main ripple (0.2 - 0.8) - Steady expansion with multiple rings
    // Phase 3: Exit fade (0.6 - 1.0) - Gentle fade like glass transparency

    // Main ripple waves - multiple concentric circles like water ripples
    final waves = _createWaterWaves(progress, maxRadius);

    for (final wave in waves) {
      if (wave['radius']! > 0 && wave['opacity']! > 0) {
        _drawWave(canvas, center, wave);
      }
    }

    // Glass shimmer effect - subtle highlight
    if (progress > 0.1 && progress < 0.7) {
      _drawGlassShimmer(canvas, center, maxRadius, progress);
    }
  }

  List<Map<String, double>> _createWaterWaves(
    double progress,
    double maxRadius,
  ) {
    // Create multiple waves with different timings for realistic water effect
    final waves = <Map<String, double>>[];

    // Primary wave - main expansion
    final primaryProgress = progress;
    final primaryOpacity = _calculateWaveOpacity(progress, 0, 1);
    waves.add({
      'radius': maxRadius * primaryProgress,
      'opacity': primaryOpacity * 0.3,
      'strokeWidth': 0.0, // Filled circle
    });

    // Secondary wave - follows behind primary (water ripple effect)
    if (progress > 0.15) {
      final secondaryProgress = ((progress - 0.15) / 0.85).clamp(0.0, 1.0);
      final secondaryOpacity = _calculateWaveOpacity(secondaryProgress, 0, 1);
      waves.add({
        'radius': maxRadius * secondaryProgress * 0.7,
        'opacity': secondaryOpacity * 0.2,
        'strokeWidth': 0.0,
      });
    }

    // Tertiary wave - creates depth
    if (progress > 0.3) {
      final tertiaryProgress = ((progress - 0.3) / 0.7).clamp(0.0, 1.0);
      final tertiaryOpacity = _calculateWaveOpacity(tertiaryProgress, 0, 1);
      waves.add({
        'radius': maxRadius * tertiaryProgress * 0.5,
        'opacity': tertiaryOpacity * 0.15,
        'strokeWidth': 0.0,
      });
    }

    // Ring waves - outer rings like water surface tension
    if (progress > 0.5) {
      final ringProgress = ((progress - 0.5) / 0.5).clamp(0.0, 1.0);
      final ringOpacity = _calculateWaveOpacity(ringProgress, 0, 0.8) * 0.1;

      // Create 2-3 ring waves
      for (var i = 0; i < 3; i++) {
        final ringRadius = maxRadius * (ringProgress + i * 0.1);
        if (ringRadius <= maxRadius) {
          waves.add({
            'radius': ringRadius,
            'opacity': ringOpacity * (1.0 - i * 0.3),
            'strokeWidth': 2.0 + i, // Ring effect
          });
        }
      }
    }

    return waves;
  }

  double _calculateWaveOpacity(
    double progress,
    double startFade,
    double endFade,
  ) {
    // Glass-like opacity curve: quick fade in, hold, gentle fade out
    if (progress < 0.2) {
      // Fast entry like water drop impact
      return (progress / 0.2).clamp(0.0, 1.0);
    } else if (progress < 0.6) {
      // Stable phase like glass surface
      return 1;
    } else {
      // Slow exit like glass becoming transparent
      final fadeProgress = (progress - 0.6) / 0.4;
      return (1.0 - math.pow(fadeProgress, 2)).clamp(0.0, 1.0);
    }
  }

  void _drawWave(Canvas canvas, Offset center, Map<String, double> wave) {
    final radius = wave['radius']!;
    final opacity = wave['opacity']!;
    final strokeWidth = wave['strokeWidth']!;

    // Use cached paint for performance
    final paintKey = _getPaintKey(opacity, strokeWidth);
    var paint = _paintCache[paintKey] ?? Paint();

    if (!_paintCache.containsKey(paintKey)) {
      paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = strokeWidth > 0 ? PaintingStyle.stroke : PaintingStyle.fill
        ..strokeWidth = strokeWidth;

      // Add subtle blur for glass effect
      if (strokeWidth == 0) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);
      }

      _paintCache[paintKey] = paint;
    } else {
      // Update only the color for existing paint
      paint.color = color.withValues(alpha: opacity);
    }

    canvas.drawCircle(center, radius, paint);
  }

  int _getPaintKey(double opacity, double strokeWidth) {
    return (opacity * 1000).round() * 10000 + strokeWidth.round();
  }

  void _drawGlassShimmer(
    Canvas canvas,
    Offset center,
    double maxRadius,
    double progress,
  ) {
    // Create a subtle shimmer effect like light reflecting on glass
    final shimmerProgress = ((progress - 0.1) / 0.6).clamp(0.0, 1.0);
    final shimmerRadius = maxRadius * shimmerProgress * 0.3;
    final shimmerOpacity = math.sin(shimmerProgress * math.pi) * 0.1;

    if (shimmerOpacity > 0.01) {
      // Performance threshold
      // Use cached shimmer paint
      const shimmerKey = 1; // Single shimmer style
      var shimmerPaint = _shimmerPaintCache[shimmerKey] ?? Paint();

      if (!_shimmerPaintCache.containsKey(shimmerKey)) {
        shimmerPaint = Paint()
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
        _shimmerPaintCache[shimmerKey] = shimmerPaint;
      }

      shimmerPaint.color = Colors.white.withValues(alpha: shimmerOpacity);
      canvas.drawCircle(center, shimmerRadius, shimmerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.tapPosition != tapPosition;
  }
}
