import 'package:hive_manager/src/features/home/data/models/contact_section_model.dart';
import 'package:hive_manager/src/features/home/data/models/department_model.dart';
import 'package:hive_manager/src/features/home/data/models/service_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_data_model.g.dart';

@JsonSerializable()
class HomeDataModel {
  const HomeDataModel({
    required this.departments,
    required this.services,
    required this.contactSections,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDataModelFromJson(json);

  final List<DepartmentModel> departments;
  final List<ServiceModel> services;

  @JsonKey(name: 'contact_sections')
  final List<ContactSectionModel> contactSections;

  Map<String, dynamic> toJson() => _$HomeDataModelToJson(this);
}
