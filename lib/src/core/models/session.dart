import 'package:freezed_annotation/freezed_annotation.dart';

// import 'package:hive_manager/src/core/utils/jwt_decoder.dart';
// import 'package:hive_manager/src/features/onboarding/data/enums/enums.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
@JsonSerializable()
class Session with _$Session {
  Session({this.accessToken, this.companyName});

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  @override
  @JsonKey(includeToJson: false)
  final String? accessToken;

  @override
  @JsonKey(includeToJson: false)
  final String? companyName;
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
