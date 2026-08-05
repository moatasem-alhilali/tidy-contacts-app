import 'package:json_annotation/json_annotation.dart';

part 'department_model.g.dart';

@JsonSerializable()
class DepartmentModel {
  const DepartmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.slug,
    required this.imagePath,
    required this.imageUrl,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      _$DepartmentModelFromJson(json);

  final int id;
  final String title;
  final String description;
  final String slug;

  @JsonKey(name: 'image_path')
  final String imagePath;

  @JsonKey(name: 'image_url')
  final String imageUrl;

  Map<String, dynamic> toJson() => _$DepartmentModelToJson(this);
}
