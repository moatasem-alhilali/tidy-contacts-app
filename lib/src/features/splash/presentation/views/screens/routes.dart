import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/src/features/splash/presentation/views/screens/routes.gr.dart';

@AutoRouterConfig(
  generateForDir: ['lib/src/features/splash/presentation/views/screens'],
)
final class Routes {
  Routes(this.ref);

  final Ref ref;

  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      initial: true,
      page: SplashRoute.page,
      // Guards are now handled globally in AppRouter
    ),
  ];
}
