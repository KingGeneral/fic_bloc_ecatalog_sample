part of 'get_pagination_product_bloc.dart';

@immutable
abstract class GetPaginationProductEvent {}

class GetProductPaginationEvent extends GetPaginationProductEvent {}

class LoadMoreProductPaginationEvent extends GetPaginationProductEvent {
  final int page;
  final int limit;
  LoadMoreProductPaginationEvent({
    required this.page,
    required this.limit,
  });
}
