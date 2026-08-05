// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactPointModel _$ContactPointModelFromJson(Map<String, dynamic> json) =>
    ContactPointModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      phone: json['phone'] as String,
      type: json['type'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$ContactPointModelToJson(ContactPointModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'phone': instance.phone,
      'type': instance.type,
      'slug': instance.slug,
    };
