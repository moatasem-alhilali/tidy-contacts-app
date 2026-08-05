// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeDataState)
final homeDataStateProvider = HomeDataStateProvider._();

final class HomeDataStateProvider
    extends $AsyncNotifierProvider<HomeDataState, HomeDataModel> {
  HomeDataStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDataStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeDataStateHash();

  @$internal
  @override
  HomeDataState create() => HomeDataState();
}

String _$homeDataStateHash() => r'b81965b5567b6bc1744450ebdca2911d2ce0e41c';

abstract class _$HomeDataState extends $AsyncNotifier<HomeDataModel> {
  FutureOr<HomeDataModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HomeDataModel>, HomeDataModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HomeDataModel>, HomeDataModel>,
              AsyncValue<HomeDataModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
