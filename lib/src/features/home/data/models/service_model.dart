import 'package:json_annotation/json_annotation.dart';

part 'service_model.g.dart';

@JsonSerializable()
class ServiceModel {
  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.slug,
    required this.imagePath,
    required this.imageUrl,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  final int id;
  final String title;
  final String description;
  final String slug;

  @JsonKey(name: 'image_path')
  final String imagePath;

  @JsonKey(name: 'image_url')
  final String imageUrl;

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}
