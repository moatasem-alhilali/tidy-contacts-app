import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/env/env.dart';
import 'package:hive_manager/src/core/di/injection_container.dart';
import 'package:hive_manager/src/features/home/data/api/home_api.dart';
import 'package:hive_manager/src/features/home/data/repositories/home_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'injection_container.g.dart';

@riverpod
HomeApi homeApi(Ref ref) =>
    HomeApi(ref.read(dioClientProvider), baseUrl: Env.BASE_URL);

@riverpod
HomeRepository homeRepository(Ref ref) =>
    HomeRepositoryImp(ref.read(homeApiProvider));
