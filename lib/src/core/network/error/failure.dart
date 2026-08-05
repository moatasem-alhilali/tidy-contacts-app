import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_manager/src/core/enums/enums.dart';

part 'failure.g.dart';

@JsonSerializable()
class Failure implements Exception {
  Failure(this.statusCode, this.message, this.code);

  factory Failure.fromJson(Map<String, dynamic> json) =>
      _$FailureFromJson(json);

  int statusCode;
  String message;
  @Default(FailureCode.UNKNOWN)
  @JsonKey(
    unknownEnumValue: FailureCode.UNKNOWN,
    defaultValue: FailureCode.UNKNOWN,
  )
  FailureCode code;
}
