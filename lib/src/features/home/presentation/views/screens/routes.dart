import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/src/features/home/presentation/views/screens/routes.dart';

export 'routes.gr.dart';

@AutoRouterConfig(
  generateForDir: ['lib/src/features/home/presentation/views/screens'],
)
final class Routes extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/main',
      page: MainRoute.page,
      
      children: [],
    ),
  ];

  static final routerKey = GlobalKey<AutoRouterState>();
}
