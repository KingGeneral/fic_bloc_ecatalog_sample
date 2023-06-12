import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/product/get_products/products_bloc.dart';
import 'package:flutter_ecatalog/bloc/product/update_product/update_product_bloc.dart';
import 'package:flutter_ecatalog/data/models/request/product_request_model.dart';
import 'package:flutter_ecatalog/data/models/response/product_response_model.dart';
import 'package:flutter_ecatalog/state_util.dart';

import '../view/home_view.dart';

class HomeController extends State<HomeView> implements MvcController {
  static late HomeController instance;
  late HomeView view;

  TextEditingController? titleController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;

  TextEditingController? titleUpdateController;
  TextEditingController? priceUpdateController;
  TextEditingController? descriptionUpdateController;

  //form key
  final formUpdateKey = GlobalKey<FormState>();

  @override
  void initState() {
    instance = this;
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();

    titleUpdateController = TextEditingController();
    priceUpdateController = TextEditingController();
    descriptionUpdateController = TextEditingController();
    super.initState();
    context.read<ProductsBloc>().add(GetProductsEvent());
  }

  @override
  void dispose() {
    super.dispose();
    titleController!.dispose();
    priceController!.dispose();
    descriptionController!.dispose();

    titleUpdateController!.dispose();
    priceUpdateController!.dispose();
    descriptionUpdateController!.dispose();
    formUpdateKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  void updateProduct(
      BuildContext context, String title, int price, String description, id) {
    final product = ProductRequestModel(
      title: title,
      price: price,
      description: description,
    );
    context
        .read<UpdateProductBloc>()
        .add(UpdateProductEventInitial(model: product, id: id));

    //refresh
    // refresh(context);
  }

  void refresh(BuildContext context) {
    // await Future.delayed(const Duration(seconds: 1));

    context.read<ProductsBloc>().add(GetProductsEvent());
  }
}
