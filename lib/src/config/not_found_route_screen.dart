import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_manager/design-system-package/siolla_design_system.dart';

// TODOadd it to the new auto route
class NotFoundRouteScreen extends StatelessWidget {
  const NotFoundRouteScreen({super.key, this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: FailureWidget(
          title: 'cant_reach_data',
          subtitle: error?.toString(),
          buttonText: 'ok',
          image: '',
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}
