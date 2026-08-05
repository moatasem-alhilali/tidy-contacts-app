// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactSectionModel _$ContactSectionModelFromJson(Map<String, dynamic> json) =>
    ContactSectionModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      slug: json['slug'] as String,
      contactPoints: (json['contact_points'] as List<dynamic>)
          .map((e) => ContactPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContactSectionModelToJson(
  ContactSectionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'slug': instance.slug,
  'contact_points': instance.contactPoints,
};
