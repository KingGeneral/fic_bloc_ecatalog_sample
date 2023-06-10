import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecatalog/bloc/products/products_bloc.dart';
import 'package:flutter_ecatalog/state_util.dart';

import '../view/home_view.dart';

class HomeController extends State<HomeView> implements MvcController {
  static late HomeController instance;
  late HomeView view;

  TextEditingController? titleController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;

  @override
  void initState() {
    instance = this;
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
    context.read<ProductsBloc>().add(GetProductsEvent());
  }

  @override
  void dispose() {
    super.dispose();
    titleController!.dispose();
    priceController!.dispose();
    descriptionController!.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
