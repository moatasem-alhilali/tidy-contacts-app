import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/src/config/guards/duplicate_guard.dart';
import 'package:hive_manager/src/features/home/presentation/views/screens/routes.dart'
    as home;
import 'package:hive_manager/src/features/splash/presentation/views/screens/routes.dart'
    as splash;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_routes.g.dart';

@riverpod
AppRouter appRoutes(Ref ref) => AppRouter(ref: ref);

@AutoRouterConfig(generateForDir: ['lib/src/config'])
final class AppRouter extends RootStackRouter {
  AppRouter({required this.ref}) : super(navigatorKey: Routers.navigatorKey);
  final Ref ref;
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    ...splash.Routes(ref).routes,
    ...home.Routes().routes,
  ];

  @override
  List<AutoRouteGuard> get guards => [
    DuplicateGuard(),
    // AuthGuard(ref),
    // SplashGuard(ref),
    // RoleGuard(ref),
  ];
}

final class Routers {
  Routers._();

  static final navigatorKey = GlobalKey<NavigatorState>();
}
