import 'package:json_annotation/json_annotation.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel {
  const EmployeeModel({
    this.id,
    this.userId,
    this.departmentId,
    this.positionId,
    this.nameAr,
    this.nameEn,
    this.email,
    this.phone,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.signaturePadData,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);

  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'department_id')
  final int? departmentId;

  @JsonKey(name: 'position_id')
  final int? positionId;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  @JsonKey(name: 'name_en')
  final String? nameEn;

  final String? email;
  final String? phone;
  final String? status;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'signature_pad_data')
  final String? signaturePadData;

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);
}
