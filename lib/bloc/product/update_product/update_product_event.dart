part of 'update_product_bloc.dart';

@immutable
abstract class UpdateProductEvent {}

class UpdateProductEventInitial extends UpdateProductEvent {
  final ProductRequestModel model;
  final int id;
  UpdateProductEventInitial({required this.model, required this.id});
}
