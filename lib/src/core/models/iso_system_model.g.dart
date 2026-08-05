// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iso_system_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsoSystemModel _$IsoSystemModelFromJson(Map<String, dynamic> json) =>
    IsoSystemModel(
      id: (json['id'] as num?)?.toInt(),
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      symbole: json['symbole'] as String?,
      code: json['code'] as String?,
      specification: json['specification'] as String?,
      version: json['version'] as String?,
      image: json['image'] as String?,
      status: json['status'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$IsoSystemModelToJson(IsoSystemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
      'symbole': instance.symbole,
      'code': instance.code,
      'specification': instance.specification,
      'version': instance.version,
      'image': instance.image,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
