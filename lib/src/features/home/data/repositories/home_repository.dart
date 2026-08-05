import 'package:hive_manager/src/core/either/either.dart';
import 'package:hive_manager/src/core/network/error/error.dart';
import 'package:hive_manager/src/features/home/data/api/home_api.dart';
import 'package:hive_manager/src/features/home/data/models/home_data_model.dart';

/// Repository contract for Home feature
abstract class HomeRepository {
  /// Fetches home data wrapped in API response
  Future<Either<Failure, HomeDataModel>> getHomeData();

 
}

/// Implementation of the Home repository
class HomeRepositoryImp extends HomeRepository {
  HomeRepositoryImp(this._api);
  final HomeApi _api;

  @override
  Future<Either<Failure, HomeDataModel>> getHomeData() async {
    return Either.tryFailure(() async {
      final result = await _api.getHomeData();
      return result.response;
    });
  }

}
