import 'package:bloc/bloc.dart';
import 'package:flutter_ecatalog/data/datasources/product_datasource.dart';
import 'package:flutter_ecatalog/data/models/request/product_request_model.dart';
import 'package:flutter_ecatalog/data/models/response/product_response_model.dart';
import 'package:flutter_ecatalog/state_util.dart';
import 'package:meta/meta.dart';

part 'get_pagination_product_event.dart';
part 'get_pagination_product_state.dart';

class GetPaginationProductBloc
    extends Bloc<GetPaginationProductEvent, GetPaginationProductLoaded> {
  final ProductDataSource dataSource;

  GetPaginationProductBloc(this.dataSource)
      : super(GetPaginationProductLoaded(
          status: Status.initial,
          page: 0,
          limit: 0,
          total: 0,
          hasMore: true,
        )) {
    on<GetProductPaginationEvent>((event, emit) async {
      emit(state.copyWith(status: Status.loading));

      final result = await dataSource.getAllProductPagination(1, 10);

      print(result);

      result.fold(
        (error) => emit(state.copyWith(status: Status.error)),
        (data) => emit(state.copyWith(
          product: data,
          page: 1,
          limit: 10,
          total: data.length,
          hasMore: true,
          status: Status.loaded,
        )),
      );
    });

    on<LoadMoreProductPaginationEvent>((event, emit) async {
      emit(state.copyWith(status: Status.loading));

      final result =
          await dataSource.getAllProductPagination(event.page, event.limit);

      print(result);

      result.fold(
        (error) => emit(state.copyWith(status: Status.error)),
        (data) => emit(state.copyWith(
          product: data,
          page: event.page,
          limit: event.limit,
          total: data.length,
          hasMore: true,
          status: Status.loaded,
        )),
      );
    });
  }
}
