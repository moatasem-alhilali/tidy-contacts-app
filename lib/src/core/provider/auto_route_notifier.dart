import 'dart:async';

import 'package:hive_manager/src/core/domain/entities/auto_route_notifier_entity.dart';
import 'package:hive_manager/src/core/network/error/error.dart';
import 'package:hive_manager/src/core/provider/connection_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_route_notifier.g.dart';

@Riverpod(keepAlive: true)
class AutoRouteNotifier extends _$AutoRouteNotifier {
  Timer? _throttleTimer;
  Failure? _queuedFailure;

  @override
  AutoRouteNotifierEntity build() {
    final hasInternet = ref.watch(connectionProvider);

    // Clean up on dispose
    ref.onDispose(() {
      _throttleTimer?.cancel();
      _throttleTimer = null;
    });
    return AutoRouteNotifierEntity(hasInternet: hasInternet);
  }

  void setFailure(Failure? failure) {
    // Special case: logout must happen immediately
    // if (failure?.statusCode == 402 || failure?.code == FailureCode.SEC_001) {
    //   ref.invalidate(sessionStateProvider);
    // }

    // Throttle repeated error updates
    _queuedFailure = failure;

    if (_throttleTimer == null || !_throttleTimer!.isActive) {
      _applyFailure();
      _throttleTimer = Timer(const Duration(seconds: 5), () {
        _throttleTimer = null;
      });
    }
  }

  void _applyFailure() {
    state = state.copyWith(failure: _queuedFailure);
    _queuedFailure = null;
  }

  void clearFailure() => state.failure = null;
}
