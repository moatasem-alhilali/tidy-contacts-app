import 'package:hive_manager/src/features/home/data/models/contact_point_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_section_model.g.dart';

@JsonSerializable()
class ContactSectionModel {
  const ContactSectionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.slug,
    required this.contactPoints,
  });

  factory ContactSectionModel.fromJson(Map<String, dynamic> json) =>
      _$ContactSectionModelFromJson(json);

  final int id;
  final String title;
  final String description;
  final String slug;

  @JsonKey(name: 'contact_points')
  final List<ContactPointModel> contactPoints;

  Map<String, dynamic> toJson() => _$ContactSectionModelToJson(this);
}
