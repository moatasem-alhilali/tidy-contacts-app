import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_manager/src/core/network/error/error.dart';

part 'auto_route_notifier_entity.freezed.dart';

@freezed
class AutoRouteNotifierEntity with _$AutoRouteNotifierEntity {
  AutoRouteNotifierEntity({this.failure, this.hasInternet = false});

  @override
  Failure? failure;
  @override
  @override
  bool hasInternet;
}
