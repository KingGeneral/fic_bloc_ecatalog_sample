part of 'get_pagination_product_bloc.dart';

@immutable
abstract class GetPaginationProductState {}

class GetPaginationProductInitial extends GetPaginationProductState {}

class GetPaginationProductLoading extends GetPaginationProductState {}

enum Status { initial, loading, loaded, error }

class GetPaginationProductLoaded extends GetPaginationProductState {
  final Status? status;
  final List<ProductResponseModel>? product;
  final int? page;
  final int? limit;
  final int? total;
  final bool? hasMore;
  GetPaginationProductLoaded({
    this.status,
    this.product,
    this.page,
    this.limit,
    this.total,
    this.hasMore = true,
  });

  @override
  String toString() {
    return 'GetPaginationProductLoaded(status: $status, product: $product, page: $page, limit: $limit, total: $total, hasMore: $hasMore)';
  }

  GetPaginationProductLoaded copyWith({
    Status? status,
    List<ProductResponseModel>? product,
    int? page,
    int? limit,
    int? total,
    bool? hasMore,
  }) {
    return GetPaginationProductLoaded(
      status: status ?? this.status,
      product: product ?? this.product,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class GetPaginationProductError extends GetPaginationProductState {
  final String? message;
  GetPaginationProductError({
    this.message,
  });
}
