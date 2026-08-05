import 'package:json_annotation/json_annotation.dart';

part 'contact_point_model.g.dart';

@JsonSerializable()
class ContactPointModel {
  const ContactPointModel({
    required this.id,
    required this.title,
    required this.phone,
    required this.type,
    required this.slug,
  });

  factory ContactPointModel.fromJson(Map<String, dynamic> json) =>
      _$ContactPointModelFromJson(json);

  final int id;
  final String title;
  final String phone;
  final String type;
  final String slug;

  Map<String, dynamic> toJson() => _$ContactPointModelToJson(this);
}
