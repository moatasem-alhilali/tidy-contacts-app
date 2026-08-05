part of '../pagination.dart';

class ApiPaginatedBaseResponse<T> {
  const ApiPaginatedBaseResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory ApiPaginatedBaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      ApiPaginatedBaseResponse<T>(
        data:
            (json['paginatedResult'] as List<dynamic>).map(fromJsonT).toList(),
        currentPage: (json['currentPage'] as num?)?.toInt(),
        totalPages: (json['totalPages'] as num?)?.toInt(),
        totalCount: (json['totalCount'] as num?)?.toInt(),
      );

  final int? totalCount;
  final int? totalPages;
  final int? currentPage;
  final List<T> data;

  bool get hasMore => (currentPage ?? 0) < (totalPages ?? 0);
}
