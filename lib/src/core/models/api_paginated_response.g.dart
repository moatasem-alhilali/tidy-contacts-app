// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_paginated_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiPaginatedResponse<T> _$ApiPaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiPaginatedResponse<T>(
        data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
        currentPage: (json['current_page'] as num?)?.toInt(),
        totalPages: (json['last_page'] as num?)?.toInt(),
        totalCount: (json['total'] as num?)?.toInt(),
      )
      ..perPage = (json['per_page'] as num?)?.toInt()
      ..from = (json['from'] as num?)?.toInt()
      ..to = (json['to'] as num?)?.toInt();

Map<String, dynamic> _$ApiPaginatedResponseToJson<T>(
  ApiPaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'data': instance.data.map(toJsonT).toList(),
  'total': instance.totalCount,
  'last_page': instance.totalPages,
  'per_page': instance.perPage,
  'from': instance.from,
  'to': instance.to,
};
