import 'package:hive_manager/src/features/home/data/di/injection_container.dart';
import 'package:hive_manager/src/features/home/data/models/home_data_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_data_provider.g.dart';

// Complete home data provider
@Riverpod(keepAlive: true)
class HomeDataState extends _$HomeDataState {
  @override
  Future<HomeDataModel> build() async {
    state = const AsyncLoading();
    final service = ref.read(homeRepositoryProvider);
    final result = await service.getHomeData();

    if (result.isLeft) throw result.left;
    return result.right;
  }
}
