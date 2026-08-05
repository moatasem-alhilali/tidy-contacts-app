import 'package:json_annotation/json_annotation.dart';

part 'iso_system_model.g.dart';

@JsonSerializable()
class IsoSystemModel {
  const IsoSystemModel({
    this.id,
    this.nameAr,
    this.nameEn,
    this.symbole,
    this.code,
    this.specification,
    this.version,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory IsoSystemModel.fromJson(Map<String, dynamic> json) =>
      _$IsoSystemModelFromJson(json);

  final int? id;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  @JsonKey(name: 'name_en')
  final String? nameEn;

  final String? symbole;
  final String? code;
  final String? specification;
  final String? version;
  final String? image;
  final bool? status;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Map<String, dynamic> toJson() => _$IsoSystemModelToJson(this);
}
