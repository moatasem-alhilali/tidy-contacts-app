import 'package:dio/dio.dart';
import 'package:hive_manager/src/core/models/api_response.dart';
import 'package:hive_manager/src/features/home/data/models/home_data_model.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api.g.dart';

@RestApi()
abstract class HomeApi {
  factory HomeApi(Dio dio, {required String baseUrl}) = _HomeApi;

  /// Get home data wrapped in ApiResponse
  @GET('/home')
  Future<ApiResponse<HomeDataModel>> getHomeData();
}
