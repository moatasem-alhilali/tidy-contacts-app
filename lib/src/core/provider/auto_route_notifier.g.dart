// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_route_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AutoRouteNotifier)
final autoRouteProvider = AutoRouteNotifierProvider._();

final class AutoRouteNotifierProvider
    extends $NotifierProvider<AutoRouteNotifier, AutoRouteNotifierEntity> {
  AutoRouteNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoRouteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoRouteNotifierHash();

  @$internal
  @override
  AutoRouteNotifier create() => AutoRouteNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AutoRouteNotifierEntity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AutoRouteNotifierEntity>(value),
    );
  }
}

String _$autoRouteNotifierHash() => r'1b086f07525faad0a1b656f884996b73cc28d554';

abstract class _$AutoRouteNotifier extends $Notifier<AutoRouteNotifierEntity> {
  AutoRouteNotifierEntity build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AutoRouteNotifierEntity, AutoRouteNotifierEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AutoRouteNotifierEntity, AutoRouteNotifierEntity>,
              AutoRouteNotifierEntity,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
