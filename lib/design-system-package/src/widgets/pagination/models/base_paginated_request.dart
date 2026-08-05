part of '../pagination.dart';

/// A base class for paginated API requests.
/// Provides default pagination parameters and a standard interface for query serialization.
class BasePaginatedRequest {
  const BasePaginatedRequest({
    this.page = 1,
    this.limit = 10,
  });
  final int? page;
  final int? limit;

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
      };
}
