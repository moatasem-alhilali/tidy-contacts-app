// Splash — redesigned: an "app icon" mark that scales + fades in, the name
// underneath, and a slim animated progress bar. No typewriter/dots.

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late final AnimationController _reveal;
  late final AnimationController _progress;

  @override
  void initState() {
    super.initState();
    _reveal = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..forward();

    _progress.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed && mounted) {
        context.router.replace(const MainRoute());
      }
    });
  }

  @override
  void dispose() {
    _reveal.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final Curve curve = Curves.easeOutBack;

    return AdaptiveScaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: CurvedAnimation(parent: _reveal, curve: curve),
                  child: FadeTransition(
                    opacity: _reveal,
                    child: Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(28),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            cs.primary,
                            Color.lerp(cs.primary, cs.tertiary, 0.6)!,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withValues(alpha: 0.35),
                            blurRadius: 28,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.contacts_rounded,
                        color: Colors.white,
                        size: 52,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _reveal,
                  child: Text(
                    Constants.get.appName,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: SizedBox(
                width: 160,
                child: AnimatedBuilder(
                  animation: _progress,
                  builder: (BuildContext context, Widget? child) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(999)),
                      child: LinearProgressIndicator(
                        value: _progress.value,
                        minHeight: 4,
                        backgroundColor: cs.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
