import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';
import 'package:hive_manager/src/core/utils/constants.dart';
import 'package:hive_manager/src/features/home/presentation/views/screens/routes.gr.dart';

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _typewriterController;
  late AnimationController _loadingController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _typewriterAnimation;
  late Animation<double> _loadingAnimation;

  String _displayText = '';
  final String _fullText = Constants.get.appName;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Typewriter animation
    _typewriterController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Define animations
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _typewriterAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _typewriterController, curve: Curves.easeInOut),
    );

    _loadingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startAnimations() async {
    // Start fade animation
    await _fadeController.forward();

    // Start typewriter effect
    _typewriterController.addListener(() {
      final progress = _typewriterAnimation.value;
      final charCount = (progress * _fullText.length).round();
      setState(() {
        _displayText = _fullText.substring(0, charCount);
      });
    });

    await _typewriterController.forward();

    // Start loading animation
    _loadingController.repeat();

    // Wait for a moment then navigate
    await Future.delayed(const Duration(milliseconds: 1500));

    // Navigate to next screen
    if (mounted) {
      context.router.replace(const MainRoute());
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _typewriterController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scaffoldBackgroundColor: context.colors.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            // App name with typewriter effect
            Column(
              children: [
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _displayText,
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 48,
                                    letterSpacing: 2,
                                    color: context.colors.brandColor,
                                    height: 1.2,
                                  ),
                            ),
                            // Blinking cursor effect
                            if (_typewriterAnimation.value < 1)
                              TextSpan(
                                text: '|',
                                style: Theme.of(context).textTheme.displayLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 48,
                                      letterSpacing: 2,
                                      color: context.colors.brandColor
                                          .withOpacity(0.8),
                                      height: 1.2,
                                    ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Enhanced loading indicator
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _typewriterAnimation,
                    _loadingAnimation,
                  ]),
                  builder: (context, child) {
                    return Opacity(
                      opacity: _typewriterAnimation.value,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Loading dots
                              for (int i = 0; i < 3; i++)
                                AnimatedBuilder(
                                  animation: _loadingAnimation,
                                  builder: (context, child) {
                                    final delay = i * 0.2;
                                    final animationValue =
                                        (_loadingAnimation.value + delay) % 1.0;
                                    final opacity = (animationValue * 2).clamp(
                                      0.0,
                                      1.0,
                                    );

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: context.colors.brandColor
                                            .withOpacity(opacity),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),

            // const Spacer(),

            // Copyright notice
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Text(
                        '© ${DateTime.now().year} $_fullText All rights reserved.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.colors.primary.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
