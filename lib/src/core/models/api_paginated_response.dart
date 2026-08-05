// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_manager/design-system-package/src/widgets/pagination/pagination.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_paginated_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiPaginatedResponse<T> implements ApiPaginatedBaseResponse<T> {
  ApiPaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory ApiPaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiPaginatedResponseFromJson(json, fromJsonT);

  @override
  @JsonKey(name: 'current_page')
  int? currentPage;

  @override
  @JsonKey(name: 'data')
  List<T> data;

  @override
  @JsonKey(name: 'total')
  int? totalCount;

  @override
  @JsonKey(name: 'last_page')
  int? totalPages;

  @override
  @JsonKey(name: 'per_page')
  int? perPage;

  @override
  @JsonKey(name: 'from')
  int? from;

  @override
  @JsonKey(name: 'to')
  int? to;

  @override
  bool get hasMore => (currentPage ?? 0) < (totalPages ?? 0);

  /// Whether there is a next page available
  bool get hasNextPage => (currentPage ?? 0) < (totalPages ?? 0);

  /// Whether there is a previous page available
  bool get hasPreviousPage => (currentPage ?? 0) > 0;

  ApiPaginatedBaseResponse<E> mapPaginated<E>(E Function(T) mapper) {
    return ApiPaginatedBaseResponse<E>(
      data: data.map(mapper).toList(),
      currentPage: currentPage,
      totalPages: totalPages,
      totalCount: totalCount,
    );
  }
}
